#ifndef TIMER_H
#define TIMER_H

#include <QThread>
#include <QAudioOutput>
#include <QAudioFormat>
#include <QFile>
#include <atomic>
#include <QDebug>

class MetronomeIODevice : public QIODevice
{
    Q_OBJECT
public:
    explicit MetronomeIODevice(QObject *parent = nullptr)
        : QIODevice(parent)
    {
        open(QIODevice::ReadOnly);
    }

    void setCycle(const QByteArray &data) {
        buffer = data;
        pos = 0;
    }

    qint64 readData(char *data, qint64 maxlen) override {
        if (buffer.isEmpty())
            return 0;

        qint64 totalRead = 0;

       while (totalRead < maxlen) {
            if (pos >= buffer.size())
                pos = 0; // redémarre le cycle

            qint64 chunk = qMin(maxlen - totalRead, buffer.size() - pos);
            memcpy(data + totalRead, buffer.data() + pos, chunk);
            pos += chunk;
            totalRead += chunk;
        }
        return totalRead;
    }

    qint64 writeData(const char*, qint64) override { return 0; }

    qint64 bytesAvailable() const override {
        return buffer.size()-pos;
    }

private:
    QByteArray buffer;
    qint64 pos = 0;
};

class Timer:public QObject
{
    Q_OBJECT
public:
    explicit Timer(QObject *parent = nullptr);
    ~Timer();

    Q_INVOKABLE void startTimer();              // démarre le métronome
    Q_INVOKABLE void stopTimer();               // arrête tout
    Q_INVOKABLE void setTickingValue(int bpm);  // change le BPM
    Q_INVOKABLE void stressBeat(int n);    
    Q_INVOKABLE void setVolume(int n); 
private:
    void rebuildCycle();

    int m_bpm = 100;
    int stressbeat = 0 ;
    float gain=1;

    QAudioFormat m_format;
    QAudioOutput *m_output = nullptr;
    MetronomeIODevice *m_device = nullptr;

    QByteArray m_clickData;
    QByteArray m_clickData2;    
};

#endif // TIMER_H
