#pragma once

template <class T> class TLock
{
	T& m_critsec;

	TLock(const TLock&) = delete;

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
