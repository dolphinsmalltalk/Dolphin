/******************************************************************************

	File: CriticalSection.h

  	Author: Blair McGlashan

	Description:

******************************************************************************/
#ifndef _CriticalSection_H_
#define _CriticalSection_H_

class CMonitor
{
public:
	CMonitor() {InitializeCriticalSection(&m_cs);}
	~CMonitor() {DeleteCriticalSection(&m_cs);}

	void Lock()	{EnterCriticalSection(&m_cs);}
	void Unlock() {LeaveCriticalSection(&m_cs);}

private:
	CRITICAL_SECTION	m_cs;
};

template <class _T> class CAutoLock
{
	_T& m_mutex;

private:
	// Suppress copy constructor and assignment operator
	const CAutoLock& operator=(const CAutoLock&);
	CAutoLock(const CAutoLock&);

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

#endif