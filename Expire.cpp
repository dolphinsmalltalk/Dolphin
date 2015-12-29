/******************************************************************************

	File: Expire.cpp

	Description:
		Image Expiry

******************************************************************************/
#include "ist.h"

// We want this to consume as little space as possible
#ifdef NDEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include <time.h>
#include "objmem.h"
#include "interprt.h"
#include "rc_vm.h"
#include "STMethodContext.h"


// A DATEWORD is 16 bits with the format: yyyyyyymmmmddddd.
#define YEAR0 (1997)
#define IMMINENT_EXPIRY (30)

#define FIXED_ZERO_DATE DDMMYYYY_AS_DATEWORD(1, 10, 2000)
//#define FIXED_EXPIRY DDMMYYYY_AS_DATEWORD(31, 10, 2000)

#define DDMMYYYY_AS_DATEWORD(dd, mm, yyyy) \
	( (WORD) ((dd-1) | ((mm-1)<<5) | ((yyyy-YEAR0)<<9) ))

WORD __stdcall ObjectMemory::todayAsDATEWORD()
{
	SYSTEMTIME t;
	GetSystemTime(&t);
	return DDMMYYYY_AS_DATEWORD(t.wDay, t.wMonth, t.wYear);
}

#define DD_FROM_DATEWORD(dw) \
	( (WORD)(dw&0x1f) + 1 )

#define MM_FROM_DATEWORD(dw) \
	( (WORD)((dw>>5)&0xf) + 1 )

#define YYYY_FROM_DATEWORD(dw) \
	( (WORD)((dw>>9)&0x7f) + YEAR0 )

// WARNING: The DIFF_DATEWORDS macro is in no way accurate. It provides a very
// rough estimate of the difference in days between the two DATEWORD parameters.
inline int DIFF_DATEWORDS(WORD dw1, WORD dw2)
{
	return (YYYY_FROM_DATEWORD(dw2)-YYYY_FROM_DATEWORD(dw1)) * 365 +
		(MM_FROM_DATEWORD(dw2)-MM_FROM_DATEWORD(dw1)) * 30 +
		(DD_FROM_DATEWORD(dw2)-DD_FROM_DATEWORD(dw1));
}

#if !defined(OAD)

inline void ObjectMemory::ShowExpiryDialog()
{
	// Shows the "Image has Expired" dialog.
	::DolphinMessageBox(IsWrongMachine(false)?IDP_WRONGMACHINE:IDP_PERMEXPIRED, 
							MB_ICONERROR, imageStamp.dwSerialNo);
}

bool ObjectMemory::HasMachineLockedLicense()
{
	return imageStamp.bIsMachineLocked && imageStamp.dwSerialNo != 0;
}

bool ObjectMemory::IsWrongMachine(bool bIsExe)
{
	return HasMachineLockedLicense() && !bIsExe && (GetMachineId() != imageStamp.dwSerialNo);
}

// Notes:
//	- ExpireIfNecessary is called on image load, but before any Smalltalk is run. If it returns false
//		the the load is aborted, and Dolphin will not start.
//	- After the boot the image is ready to expire, but is not actually expired yet.
//	- The LastSaveDate is not actually set until the first save from the VM DLL, and therefore the image
//		cannot expire until the next restart after the completion of the second boot phase
//	- For a development image, boot part 2 should unlock the image.
//	- For a release image, the first start will expire the image, but not refuse to load it (unless it couldn't be
//		saved in expired state). The image must then be unlocked, or subsequently it cannot be loaded at all.
//		i.e. Only one attempt is permitted at unlocking the image on each install (although of course the unlock
//		sequence in the image may permit multiple attempts).
HRESULT ObjectMemory::ExpireIfNecessary(const char* szFileName, bool bIsExe)
{
	WORD today = todayAsDATEWORD();
	bool bOk = imageStamp.wLastSaveDate == NULL;

	if (!bOk)
	{
		if (imageStamp.bIsExpired)
		{
			// The image has already expired, show the expiry dialog.
			ShowExpiryDialog();
		}
		else
		{
			bool bIsWrongMachine = IsWrongMachine(bIsExe);
			// Expire the image if necessary.
			if (bIsWrongMachine || (today >= imageStamp.wExpiryDate))
			{
				// The image has just passed the use-by-date/maximum image save count
				bOk = Expire(szFileName) && !bIsWrongMachine;

				// Show the expiry dialog, but allow the image to continue this once 
				// (if not a .EXE in which case Expire will fail, aborting the load)
				ShowExpiryDialog();
			}
			else if (today < imageStamp.wLastSaveDate)
			{
				bOk = ClockSetBack();
			}
			else if (DIFF_DATEWORDS(today, imageStamp.wExpiryDate) < IMMINENT_EXPIRY)
			{
				// The image will expire within IMMINENT_EXPIRY days.
				bOk = ExpiryImminent();
			}
			else
				bOk = !bOk;
		}
	}

	return bOk ? S_OK : E_FAIL;
}

bool ObjectMemory::ClockSetBack()
{
	::DolphinMessageBox(IDP_CLOCKSETBACK, MB_ICONEXCLAMATION,
		DD_FROM_DATEWORD(imageStamp.wLastSaveDate),
		MM_FROM_DATEWORD(imageStamp.wLastSaveDate),
		YYYY_FROM_DATEWORD(imageStamp.wLastSaveDate),
		imageStamp.dwSerialNo);
	// Don't permit load
	return false;
}

bool ObjectMemory::ExpiryImminent()
{
	// The image will expire within the next few days. Show a message
	// to that effect.

	::DolphinMessageBox(IDP_NEARLYEXPIRED, MB_ICONERROR,
		DD_FROM_DATEWORD(imageStamp.wExpiryDate),
		MM_FROM_DATEWORD(imageStamp.wExpiryDate),
		YYYY_FROM_DATEWORD(imageStamp.wExpiryDate),
		imageStamp.dwSerialNo);

	// Permit load
	return true;
}

#endif

void ObjectMemory::InitializeImageStamp(void)
{
#ifdef _AFX
	// Prepare the image for release.
	imageStamp.wLastSaveDate = 0;
	imageStamp.dwSavesRemaining = 0xFFFFF000;	

	WORD today=todayAsDATEWORD();

	imageStamp.wImageBootDate = today;

	// Set the ZeroDate to be the beginning of this month (this == 0) for jan97.
	#if defined(FIXED_ZERO_DATE)
		ObjectMemory::imageStamp.wZeroDate = FIXED_ZERO_DATE;
	#else
		WORD mm=MM_FROM_DATEWORD(today);
		WORD yyyy=YYYY_FROM_DATEWORD(today);
		ObjectMemory::imageStamp.wZeroDate = DDMMYYYY_AS_DATEWORD(1, mm, yyyy);
	#endif

	#ifdef FIXED_EXPIRY
		imageStamp.wExpiryDate = FIXED_EXPIRY;
	#else
		imageStamp.wExpiryDate = 0;
	#endif

	// We don't want it to be expired until it is loaded for the first time from the post
	// boot part 2 image
	imageStamp.bIsExpired = false;
#else
	memset(&imageStamp, 0, sizeof(ImageStamp));
#endif
}


void ObjectMemory::LoadedImageStamp(Context* imageStampContext)
{
	// Transfer the information from the special MethodContext into ObjectMemory.

	ImageStamp* stamp = reinterpret_cast<ImageStamp*>(&(imageStampContext->m_tempFrame));
	memcpy(&imageStamp, stamp, sizeof(ImageStamp));
}

#ifdef TIMEDEXPIRY
/*
unlockVM: serialNumber expiry: expiryMonths machinedLocked: machineLockedFlag
	"Private - Unlock the VM and serialize it with the <Integer> serialNumber. The image
	will continue to run for a period indicated by <Integer> expiryMonths this is zero then
	the image will never expire. If the machineLockedFlag <integer> is 1, then
	the image is considered locked to the machine identified by the serial number."
*/

bool ObjectMemory::UnlockImage(DWORD dwSerialNo, WORD monthsExt, BOOL bIsMachineLocked)
{
	// Unlocks the image if the password is valid.
	
	imageStamp.dwSerialNo = dwSerialNo;
	imageStamp.wExtensions++;

	imageStamp.dwSavesRemaining = 0xFFFFF000;
	if (monthsExt == 0)
	{
		imageStamp.wExpiryDate = 0xFFFF;
		imageStamp.bIsExpired = false;
	}
	else
	{
#pragma warning(disable:4244) // Conversion from int to unsigned short, possible loss of data
		// Extend the expiryDate monthsExt months forward from the wZeroDate.
		WORD mm = MM_FROM_DATEWORD(ObjectMemory::imageStamp.wZeroDate);
		WORD yyyy = YYYY_FROM_DATEWORD(ObjectMemory::imageStamp.wZeroDate);
		mm += monthsExt;
		if (mm>12)
		{
			yyyy += mm/12;
			mm=mm%12; 
		}

		// The follwing sets the expiry date if the VM is time protected
		imageStamp.wExpiryDate = DDMMYYYY_AS_DATEWORD(1, mm, yyyy);
		WORD today = todayAsDATEWORD();
		imageStamp.bIsExpired = today >= imageStamp.wExpiryDate;
#pragma warning(default:4244) // Conversion from int to unsigned short, possible loss of data
	}

#pragma warning(disable:4800)
	imageStamp.bIsMachineLocked = bIsMachineLocked;
#pragma warning(default:4800)

	// Do we want to save the image here?
	//imageStamp.dwSavesRemaining += 1;
	//SaveImageFile(szFileName);

	return !imageStamp.bIsExpired;
}

#endif