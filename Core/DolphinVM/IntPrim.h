#pragma once

struct bit_xor {
	constexpr Oop operator() (const Oop& receiver, const Oop& arg) const {
		return receiver ^ (arg - 1);
	}
};
