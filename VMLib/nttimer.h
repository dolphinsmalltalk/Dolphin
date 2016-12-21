#pragma once

#include <minwindef.h>
//#include <ntstatus.h>

// Can't include ntdef.h because it clashes with winnt.h
//#include <ntdef.h>
typedef _Return_type_success_(return >= 0) LONG NTSTATUS;
typedef void* POBJECT_ATTRIBUTES;
typedef enum _TIMER_TYPE {
	NotificationTimer,
	SynchronizationTimer
} TIMER_TYPE;

#pragma comment(lib, "ntdll.lib")

extern "C" {

	NTSYSAPI
		NTSTATUS
		NTAPI
		NtCancelTimer(
			IN HANDLE               TimerHandle,
			OUT PBOOLEAN            CurrentState OPTIONAL);

	NTSYSAPI
		NTSTATUS
		NTAPI
		NtCreateTimer(
			OUT PHANDLE             TimerHandle,
			IN ACCESS_MASK          DesiredAccess,
			IN POBJECT_ATTRIBUTES   ObjectAttributes OPTIONAL,
			IN TIMER_TYPE           TimerType);

	typedef void(CALLBACK * PTIMER_APC_ROUTINE)(
		IN PVOID TimerContext,
		IN ULONG TimerLowValue,
		IN LONG TimerHighValue
		);

	NTSYSAPI
		NTSTATUS
		NTAPI
		NtSetTimer(
			IN HANDLE               TimerHandle,
			IN PLARGE_INTEGER       DueTime,
			IN PTIMER_APC_ROUTINE   TimerApcRoutine OPTIONAL,
			IN PVOID                TimerContext OPTIONAL,
			IN BOOLEAN              ResumeTimer,
			IN LONG                 Period OPTIONAL,
			OUT PBOOLEAN            PreviousState OPTIONAL);

	NTSYSAPI
		NTSTATUS
		NTAPI
		NtSetTimerResolution(
			IN ULONG RequestedResolution,
			IN BOOLEAN Set,
			OUT PULONG ActualResolution
		);

	NTSYSAPI
		NTSTATUS
		NTAPI
		NtQueryTimerResolution(
			OUT PULONG MinimumResolution,
			OUT PULONG MaximumResolution,
			OUT PULONG ActualResolution
		);

}