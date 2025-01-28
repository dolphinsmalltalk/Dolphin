#pragma once

#include "ist.h"

class VirtualMemoryStats
{
	MEMORYSTATUSEX memStats;

public:
	VirtualMemoryStats()
	{
		ZeroMemory(&memStats, sizeof(memStats));
		memStats.dwLength = sizeof(MEMORYSTATUSEX);
		::GlobalMemoryStatusEx(&memStats);
	}

	__declspec(property(get = get_VirtualMemoryTotal)) size_t VirtualMemoryTotal;
	size_t get_VirtualMemoryTotal() const
	{
		return static_cast<size_t>(memStats.ullTotalVirtual);
	}

	__declspec(property(get = get_VirtualMemoryTotalMb)) size_t VirtualMemoryTotalMb;
	size_t get_VirtualMemoryTotalMb() const
	{
		return VirtualMemoryTotal / (1024 * 1024);
	}

	__declspec(property(get = get_VirtualMemoryUsed)) size_t VirtualMemoryUsed;
	size_t get_VirtualMemoryUsed() const
	{
		return VirtualMemoryTotal - VirtualMemoryFree;
	}

	__declspec(property(get = get_VirtualMemoryUsedMb)) size_t VirtualMemoryUsedMb;
	size_t get_VirtualMemoryUsedMb() const
	{
		return VirtualMemoryUsed / (1024 * 1024);
	}

	// Virtual memory is only free in the sense that the address space is available to allocate,
	// nevertheless for a 32-bit process on a 64-bit host that likely has much more physical
	// memory available, this does tend to be the final limiting factor when allocating memory.
	__declspec(property(get = get_VirtualMemoryFree)) size_t VirtualMemoryFree;
	size_t get_VirtualMemoryFree() const
	{
		return static_cast<size_t>(memStats.ullAvailVirtual);
	}

	__declspec(property(get = get_VirtualMemoryFreeMb)) size_t VirtualMemoryFreeMb;
	size_t get_VirtualMemoryFreeMb() const
	{
		return VirtualMemoryFree / (1024 * 1024);
	}
};
