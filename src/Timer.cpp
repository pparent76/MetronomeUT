#include "Timer.h"
#include <QFile>
#include <QDebug>
#include <iostream>
#include <QEventLoop>
#include <QTimer>

using namespace std;

Timer::Timer(QObject *parent)
{
    m_format.setSampleRate(44100);
    m_format.setChannelCount(1);
    m_format.setSampleSize(16);
    m_format.setCodec("audio/pcm");
    m_format.setByteOrder(QAudioFormat::LittleEndian);
    m_format.setSampleType(QAudioFormat::SignedInt);

    QFile f(":/MediaFiles/click.wav");
    if (f.open(QIODevice::ReadOnly)) {
        m_clickData = f.readAll();
        f.close();
    }
    
    QFile f2(":/MediaFiles/click2.wav");
    if (f2.open(QIODevice::ReadOnly)) {
        m_clickData2 = f2.readAll();
        f2.close();
    }    

    m_device = new MetronomeIODevice();
    
    
    m_output = new QAudioOutput(m_format);
    m_output->moveToThread(QThread::currentThread());
    m_output->setVolume(0.6);
    
    rebuildCycle();
}

Timer::~Timer() {
}

void Timer::startTimer() {
    m_output->start(m_device);
}

void Timer::stopTimer() {
       if (m_output) {
            m_output->stop();
        }
}

void Timer::setTickingValue(int bpm) {
    m_bpm = bpm;
    rebuildCycle();
}


void Timer::stressBeat(int n)
{
    stressbeat=n;
    rebuildCycle();
}

void Timer::setVolume(int n)
{
    m_output->setVolume(1.0*n/100);
}


void Timer::rebuildCycle()
{
    cout<<"Build cycle"<<endl;
    if (m_clickData.isEmpty())
        return;

    double cycleSec = 60.0 / m_bpm;
    int sampleRate = m_format.sampleRate();
    int bytesPerSample = m_format.sampleSize() / 8;

    int cycleBytes = int(sampleRate * bytesPerSample * cycleSec);

    QByteArray cycle;
   // cycle.reserve(2*cycleBytes);


    static const int WAV_HEADER_SIZE = 44;
    QByteArray pcmData = m_clickData.mid(WAV_HEADER_SIZE);
    QByteArray pcmData2 = m_clickData2.mid(WAV_HEADER_SIZE);
    
    int silence = (cycleBytes - pcmData.size())/2*2;
    
    
    if (stressbeat < 2 )
    {
    cycle.append(pcmData);
    if (silence > 0)
        cycle.append(QByteArray(silence, 0));
    }
    else{
        cycle.append(pcmData2);
        if (silence > 0)
            cycle.append(QByteArray(silence, 0));
        for (int i=0;i<stressbeat-1; i++ )
        {
            cycle.append(pcmData);
            if (silence > 0)
                cycle.append(QByteArray(silence, 0));
        }
    }
    
    m_device->setCycle(cycle);
}
