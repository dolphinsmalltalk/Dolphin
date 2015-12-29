#ifndef _TLOCK_H_
#define _TLOCK_H_

template <class T> class TLock
{
	T& m_critsec;

	TLock(const TLock&) {DebugBreak();}

public:
	TLock(T& lock) : m_critsec(lock)
	{
		m_critsec.Lock();
	}

	~TLock()
	{
		m_critsec.Unlock();
	}
};

#endif