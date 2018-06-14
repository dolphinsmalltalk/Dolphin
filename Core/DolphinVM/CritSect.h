/******************************************************************************

	File: CriticalSection.h

  	Author: Blair McGlashan

	Description:

******************************************************************************/
#pragma once

class CMonitor
{
public:
	CMonitor() {InitializeCriticalSection(&m_cs);}
	~CMonitor() {DeleteCriticalSection(&m_cs);}

	void Lock()	{EnterCriticalSection(&m_cs);}
	void Unlock() {LeaveCriticalSection(&m_cs);}

private:
	// Suppress copy constructor and assignment operator
	const CMonitor& operator=(const CMonitor&) = delete;
	CMonitor(const CMonitor&) = delete;

private:
	CRITICAL_SECTION	m_cs;
};

template <class _T> class CAutoLock
{
	_T& m_mutex;

private:
	// Suppress copy constructor and assignment operator
	const CAutoLock& operator=(const CAutoLock&) = delete;
	CAutoLock(const CAutoLock&) = delete;

public:
	CAutoLock(_T& mutex) : m_mutex(mutex) 
	{
		m_mutex.Lock();
	}

	~CAutoLock()
	{
		m_mutex.Unlock();
	}
};

typedef CAutoLock<CMonitor> CMonitorLock;
