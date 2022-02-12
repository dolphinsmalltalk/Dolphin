#pragma once

struct Truncate { double operator() (const double& x) const { return x; } };
struct Floor { double operator() (const double& x) const { return floor(x); } };
struct Ceiling { double operator() (const double& x) const { return ceil(x); } };

struct Atan2 { double operator() (const double& y, const double& x) const { return atan2(y, x); } };
struct Pow { double operator() (const double& x, const double& y) const { return pow(x, y); } };
struct Sin { double operator() (const double& x) const { return sin(x); } };
struct Cos { double operator() (const double& x) const { return cos(x); } };
struct Tan { double operator() (const double& x) const { return tan(x); } };
struct ArcSin { double operator() (const double& x) const { return asin(x); } };
struct ArcCos { double operator() (const double& x) const { return acos(x); } };
struct ArcTan { double operator() (const double& x) const { return atan(x); } };
struct Exp { double operator() (const double& x) const { return exp(x); } };
struct Log { double operator() (const double& x) const { return log(x); } };
struct Log10 { double operator() (const double& x) const { return log10(x); } };
struct Sqrt { double operator() (const double& x) const { return sqrt(x); } };
struct Abs { double operator() (const double& x) const { return fabs(x); } };
struct Negated { double operator() (const double& x) const { return _chgsign(x); } };

struct FractionPart 
{
	double operator() (const double& x) const 
	{ 
		double integerPart;  
		return modf(x, &integerPart); 
	} 
};
struct IntegerPart 
{ 
	double operator() (const double& x) const 
	{ 
		double integerPart;  modf(x, &integerPart); return integerPart; 
	} 
};
