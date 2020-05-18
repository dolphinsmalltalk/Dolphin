#pragma once
#include <type_traits>

template<typename T> struct EnableBitOperators : std::false_type { };

template<typename T>
typename std::enable_if<EnableBitOperators<T>::value, T>::type
operator |(const T lhs, const T rhs)
{
	using underlying = typename std::underlying_type<T>::type;
	return static_cast<T> (
		static_cast<underlying>(lhs) |
		static_cast<underlying>(rhs)
		);
}

template<typename T>
typename std::enable_if<EnableBitOperators<T>::value, T>::type
operator &(const T lhs, const T rhs)
{
	using underlying = typename std::underlying_type<T>::type;
	return static_cast<T> (
		static_cast<underlying>(lhs) &
		static_cast<underlying>(rhs)
		);
}

template<typename T>
typename std::enable_if<EnableBitOperators<T>::value, T>::type
operator ~(const T rhs)
{
	using underlying = typename std::underlying_type<T>::type;
	return static_cast<T> (
		~static_cast<underlying>(rhs)
		);
}

template<typename T>
typename std::enable_if<EnableBitOperators<T>::value, bool>::type
operator !(const T rhs)
{
	using underlying = typename std::underlying_type<T>::type;
	return static_cast<underlying>(rhs) == 0;
}

#define ENABLE_BITMASK_OPERATORS(x) \
	template<> struct EnableBitOperators<x> : std::true_type { };

///////////////////////////////////////////////////////////////////////////////
// Integer types
//

template<typename T> struct EnableIntOperators : std::false_type { };

// operator++() - prefix
template<typename T>
typename std::enable_if<EnableIntOperators<T>::value, T>::type
operator++(T& x)
{
	using underlying = typename std::underlying_type<T>::type;
	return x = static_cast<T>(static_cast<underlying>(x) + 1);
}

// operator++(int) - postfix
template<typename T>
typename std::enable_if<EnableIntOperators<T>::value, T>::type
operator++(T& x, int)
{
	using underlying = typename std::underlying_type<T>::type;
	T current = x;
	x = static_cast<T>(static_cast<underlying>(x) + 1);
	return current;
}

template<typename T>
typename std::enable_if<EnableIntOperators<T>::value, T>::type&
operator--(T& x)
{
	_ASSERTE(x > T::npos);
	using underlying = typename std::underlying_type<T>::type;
	auto r = static_cast<underlying>(x) - 1;
	return x = static_cast<T>(r);
}

template<typename T>
typename std::enable_if<EnableIntOperators<T>::value, T>::type&
operator--(T& x, int)
{
	_ASSERTE(x > T::npos);
	using underlying = typename std::underlying_type<T>::type;
	T current = x;
	auto r = static_cast<underlying>(x) - 1;
	x = static_cast<T>(r);
	return current;
}

template<typename T, typename I>
typename std::enable_if<EnableIntOperators<T>::value, T>::type&
operator+=(T& x, const I offset)
{
	using underlying = typename std::underlying_type<T>::type;
	return x = static_cast<T>(static_cast<underlying>(x) + offset);
}

template<typename T, typename I>
typename std::enable_if<EnableIntOperators<T>::value, T>::type&
operator-=(T& x, const I offset)
{
	using underlying = typename std::underlying_type<T>::type;
	underlying r = static_cast<underlying>(x) - offset;
	return x = static_cast<T>(r);
}

template<typename T, typename I> constexpr
const typename std::enable_if<EnableIntOperators<T>::value, T>::type
operator+(const T x, const I y)
{
	using underlying = typename std::underlying_type<T>::type;
	return static_cast<T>(static_cast<underlying>(x) + static_cast<underlying>(y));
}

template<typename T, typename I> constexpr
const typename std::enable_if<EnableIntOperators<T>::value, T>::type
operator-(const T x, const I y)
{
	using underlying = typename std::underlying_type<T>::type;
	underlying r = static_cast<underlying>(x) - static_cast<underlying>(y);
	return static_cast<T>(r);
}

#define ENABLE_INT_OPERATORS(x) \
	template<> struct EnableIntOperators<x> : std::true_type { };
