typedef unsigned long	HASH;
typedef unsigned char	BYTE;

static HASH diffusion_tab[256] =
{
	0x4415630E, 0xBDEFFE8E, 0x80A6ACF2, 0x39D7E909, 
	0x7FC47AFB,  0xF25C7BE, 0x169A8C1A, 0xF222A977, 
	0x1ED1B44A, 0x3B489E6B, 0x8A1279B3, 0x25C6E43D, 
	0x43887820, 0xE435D952,  0x51BC268, 0x54850D08, 
	0x79E944F0, 0x879D4BE6, 0xC12AD6D4, 0xDEB0DB41, 
	0xAD572494, 0x72FD0028,  0x8DDF037, 0x61E51C13, 
	0x75ADABBC, 0xA5793B49, 0x7AEE8896, 0x60002565, 
	0x9978A0EC, 0xED6BBDB7, 0x5F0722F5, 0xE39F2EBD, 
	0x373FD3C2, 0xF982E05B, 0x85E215B6, 0xA8B75F76, 
	0xB9DEA702, 0xA068B66E, 0x71C957AE, 0xA989B01D, 
	0xAA3D3E8C, 0xD8F9ED5A, 0x2CF01F0B, 0x70D3D54B, 
	0x8F757FB0, 0x12AF70E2, 0xF6ABFF32, 0xBB3CF433, 
	0xFBF883AD, 0x8DC0EEB4, 0xEFE0D8FC, 0xD0BB2974, 
	0x642D5B79, 0x260D4C46, 0x2716762C, 0x5E020487, 
	0x52956186, 0x626F0321, 0x6B0997CE, 0x4FDCB197, 
	0x73102CC4, 0xEA3B6C82, 0xFE371D3C, 0x5672B934, 
	0xE943745F, 0xCAB6FDF3, 0xC3E6F317, 0xBF6D53B9, 
	0x8B8C05DA, 0x8E395CFF, 0x837D81B8, 0x48A55A03, 
	0xDB04097C, 0x8917BBFE, 0x102B8A12, 0x93C7E6AB, 
	0x97FA7C73, 0xE61FD7EA, 0x5A81C02A, 0x2954D226, 
	0x350A210F, 0x7B7CC461, 0x238048DF, 0xB1A8A566, 
	0x86FEF969, 0x636231A5, 0x34EB556C, 0xD1676831, 
	0x6D0F12CD, 0x5CF3231C, 0xE251202D, 0x31FFDFC0, 
	0x40CCDA07,  0x3848E9F, 0x3A38849D, 0xB3A7AF25, 
	0xC5CD405C, 0xCC24FC59, 0x537610D7, 0xD298B3B1, 
	0xDAB29A29, 0x817E9FC8, 0xD718CB92, 0x3EB5CA51, 
	0xABC50688, 0x901D3CB2, 0x651CD063, 0x9D3E0E93, 
	0x98EDCCDB, 0x9F1A9B4C, 0xE774E2D5, 0x2BBF36E4, 
	0x9B6E1BA1,   0xA092D8, 0x1442267F, 0x503408A7, 
	0x1F469662, 0x20772D53, 0x6ABCC9F7,  0x99E8FEE, 
	0x38D57705, 0x42CB3785, 0xFDB86218, 0xCD86BA50, 
	0xC9F53DC1, 0x2F9BDEC6, 0x7D8AA480, 0xA759FB45, 
	0x57194371, 0xE0143F15, 0x119C4258,  0x15C661E, 
	0x45E3CF35,  0x7C2A15E, 0x337F596D, 0x3D63077B, 
	0xDC3AC53B, 0xAFE8B7BA, 0x6F1E4DE9, 0xB699CD47, 
	0x745DE839, 0xC7665019, 0xEC2E0CC9, 0x1AF69156, 
	0x47E7EB3E,  0xAB3909E, 0x15F75D70,  0x673894F, 
	0x5B92198D, 0xB55B49F9, 0x1BEAA611,  0xDD93A83, 
	0x9401E5DE, 0x324A54E0, 0xAEA98760, 0x1D608654, 
	0xBCBA723A, 0xEB8FF25D, 0x19D4F690, 0x66DF71CF, 
	0xBE7AB5CB, 0xDD05149C, 0xE10C9884, 0x49E16BC3, 
	0x1893C6D1, 0x84F4EADD, 0xC2B9BFA9, 0xC8B41A2E, 
	0xF35EC1EB, 0x59216040, 0x51D80B91, 0xCE06E3F6, 
	0x2A555EAA, 0x4E40737D, 0x765301FD, 0x2D8EA8D0, 
	0x822CB80D, 0x889782EF, 0x1C6AF5A2, 0xD9FBF148, 
	0x4B910A43, 0xB2C380CC, 0x6865BE9A, 0xA1612806, 
	0x96DA39A8, 0xF0DB383F, 0x9E703538, 0x6E132F30, 
	0xA2BE9416, 0xD371756F, 0xB728851B, 0xBA2F5264, 
	0xF5D6A3FA, 0xD649177A, 0x2236E1DC, 0x5D26562B, 
	0xCF201E8F, 0x13AEC8ED, 0xB4AC7B24, 0xF7CE4A04, 
	0x24A234D6, 0x788D0244, 0x5896DD78, 0xDF640F67, 
	0x91AA9355, 0x4D9433D2, 0x92116F36, 0x305A4772, 
	0xAC2316A4,  0xB8BB27E, 0xFF4DAA22, 0xA4F16D9B, 
	 0x2502789, 0xFCC15800, 0xB8BD3298, 0xEE6C46F4, 
	0x6C0B9C4D,  0x44CDCBF, 0x28CFFABB, 0xA3FC7E14, 
	0xE8327D01, 0x7C334F2F, 0xF830D4B5, 0x9A582A1F, 
	0x4CD2A28B, 0x4A56518A,  0xC0841E1, 0x3683994E, 
	0x7E31BCCA, 0x690313A3, 0xF144AEF8, 0xC090ECE7, 
	0x3C524E81, 0xE569656A, 0x465FE7AC, 0x9C4B6EF1, 
	0xCBA1EFD3, 0xB0E464C7, 0xC4279DE3, 0xA641950A, 
	0x2E4F67AF, 0x67A3D199, 0x8C87CE75, 0xF4D0AD0C, 
	0x17F23042, 0x21CA11E8,  0xE45C357, 0xC60E45C5, 
	0xD5EC8D27, 0x3F296AA6, 0x55C818D9, 0x41472B23, 
	0xD4B18BE5, 0xFAA46995, 0x774EF710, 0x957BF8A0, 
};

/*
 * a hash using a diffusion table by Tom Thomson.
 * Produces even better scattering and is faster than the linear congruential hash;
 * but only by a small margin
 */
HASH __stdcall
DiffusionHash(BYTE *ptr, int count)
{
	HASH	hash;
	int		i;

	for (i = 0,hash = 0; i < count;i++)
	{
		HASH rotr = (hash >> 1) | ((hash&1) << 31);
		hash = diffusion_tab[ptr[i]] ^ rotr;
	}

	return hash;
}

__declspec(naked) HASH __stdcall DiffusionHashAsm30(BYTE* ptr, int count)
{
	ptr; count;	// Suppress warning C4100, unreferenced parameter
	_asm
	{
		mov		ecx, [esp+4]
		mov		edx, [esp+8]

		// esi is used for the loop end
		push	esi
		add		edx, ecx
		xor		eax, eax				// Eax will be the returned hash code
		mov		esi, edx
		jmp		loopTail
		
	loopHead:
		ror	eax, 1					// Rotate right

		xor	edx, edx
		mov	dl, BYTE PTR [ecx]
		inc	ecx
		xor	eax, DWORD PTR diffusion_tab[edx*4]
	loopTail:
		cmp	ecx, esi
		jb	loopHead

		// 30 bits max
		and	eax, 0x3FFFFFFF
		pop	esi
		ret 8
	}
}

/*
 * a variant on the diffusion hash which always produces a 30-bit answer
 */
HASH
DiffusionHash30Bit(BYTE *ptr, int count)
{
	return DiffusionHash(ptr, count) & 0x3FFFFFFF;
}

/*
 * this hash function is a variant of a linear congruential pseudo-random number generator.
 * It produces a 32-bit hash with very good scattering;
 * eg:
 *	"aaa" -> 3,568,862,939
 *	"aab" -> 4,166,348,560
 *	"aac" ->   468,866,885
 */
__inline HASH
LinearCongruentialHash(BYTE *ptr, int count)
{
	HASH	hash;
	int i;

	for (i=0,hash=0;i<count;i++)
		hash = (hash + ptr[i]) * 597485621;

	return hash;
}


/*
 * a variant on the linerar congruential hash which always produces a 30-bit answer
 */
HASH
LinearCongruentialHash30Bit(BYTE *ptr, int count)
{
	// C shift of unsigned integer shifts in zeros from the top
	return LinearCongruentialHash(ptr, count) >> 2;
}

__declspec(naked) HASH __stdcall LinearCongruentialHashAsm30(BYTE* ptr, int count)
{
	ptr; count;
	_asm
	{
		mov		ecx, [esp+4]
		mov		edx, [esp+8]

		// esi is used for the loop end
		push	esi
		add		edx, ecx
		xor		eax, eax				// Eax will be the returned hash code
		mov		esi, edx
		jmp		loopTail
		
	loopHead:
		xor	edx, edx
		mov	dl, BYTE PTR [ecx]
		inc	ecx
		add	eax, edx
		imul eax, 597485621
	loopTail:
		cmp	ecx, esi
		jb	loopHead

		// 30 bits max
		shr	eax, 2
		pop	esi
		ret 8
	}
}

HASH
Djb2Hash30Bit(BYTE *str, int count)
{
    HASH hash = 5381;
    int i;

	for (i=0;i<count;i++)
        //hash = ((hash << 5) + hash) + str[i]; /* hash * 33 + c */
        hash = ((hash << 5) + hash) ^ str[i]; /* hash * 33 xor c */

	return hash & 0x3FFFFFFF;
}

HASH SdbmHash30Bit(BYTE* str, int count)
{
    HASH hash = 0;
    int i;

	for (i=0;i<count;i++)
        hash = str[i] + (hash << 6) + (hash << 16) - hash;

	return hash & 0x3FFFFFFF;
}

HASH DiffusionHash30Bit2(BYTE* ptr, int count)
{
	HASH	hash;
	const	BYTE* loopEnd;
	loopEnd = ptr + count;

	for (hash = 0; ptr < loopEnd;ptr++)
	{
		HASH rotr = (hash >> 1) | ((hash&1) << 31);
		hash = diffusion_tab[*ptr] ^ rotr;
	}

	return hash & 0x3FFFFFFF;
}