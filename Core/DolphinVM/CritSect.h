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
	// Suppress copy/move constructors and assignment operators
	const CMonitor& operator=(const CMonitor&) = delete;
	CMonitor& operator=(CMonitor&&) = delete;
	CMonitor(const CMonitor&) = delete;
	CMonitor(CMonitor&&) = delete;

private:
	CRITICAL_SECTION	m_cs;
};

template <class _T> class CAutoLock
{
	_T& m_lockable;

private:
	// Suppress copy/move constructors and assignment operators
	const CAutoLock& operator=(const CAutoLock&) = delete;
	CAutoLock& operator=(CAutoLock&&) = delete;
	CAutoLock(const CAutoLock&) = delete;
	CAutoLock(CAutoLock&&) = delete;

public:
	CAutoLock(_T& mutex) : m_lockable(mutex) 
	{
		m_lockable.Lock();
	}

	~CAutoLock()
	{
		m_lockable.Unlock();
	}
};
