"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbLinearRegression
	instanceVariableNames: 'sum1 sumX sumY sumXX sumYY sumXY slope intercept correlationCoefficient'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLinearRegression guid: (GUID fromString: '{E550029A-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLinearRegression comment: ''!
!DhbLinearRegression categoriesForClass!DHB Numerical! !
!DhbLinearRegression methodsFor!

add: aPoint
		"Accumulate aPoint into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	self add: aPoint weight: 1.!

add: aPoint weight: aNumber 
	"Accumulate aPoint into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := sum1 + aNumber.
	sumX := sumX + (aPoint x * aNumber).
	sumY := sumY + (aPoint y * aNumber).
	sumXX := sumXX + (aPoint x squared * aNumber).
	sumYY := sumYY + (aPoint y squared * aNumber).
	sumXY := sumXY + (aPoint x * aPoint y * aNumber).
	self resetResults!

asEstimatedPolynomial
		"Answer the resulting linear dependence found by the receiver in the form of a polynomial
		 with embedded error matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^( DhbEstimatedPolynomial coefficients: self coefficients)
			errorMatrix: self errorMatrix;
			yourself!

asPolynomial
		"Answer the resulting linear dependence found by the receiver in the form of a polynomial.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^DhbPolynomial coefficients: self coefficients!

coefficients
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "
	^Array with: self intercept with: self slope!

computeResults
	"Private - Compute the results of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	| xNorm xyNorm |
	xNorm := sumXX * sum1 - (sumX * sumX).
	xyNorm := sumXY * sum1 - (sumX * sumY).
	slope := xyNorm / xNorm.
	intercept := (sumXX * sumY - (sumXY * sumX)) / xNorm.
	correlationCoefficient := xyNorm 
				/ (xNorm * (sumYY * sum1 - (sumY * sumY))) sqrt!

correlationCoefficient
		"Answers the correlation coefficient of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	correlationCoefficient isNil
		ifTrue: [ self computeResults].
	^correlationCoefficient!

errorMatrix
	"Answer the resulting linear dependence found by the receiver in the form of a polynomial
		 with embedded error matrix.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 18/3/99 "

	| c1 cx cxx |
	c1 := 1.0 / (sumXX * sum1 - sumX squared).
	cx := sumX negated * c1.
	cxx := sumXX * c1.
	c1 := sum1 * c1.
	^DhbSymmetricMatrix rows: (Array with: (Array with: cxx with: cx)
				with: (Array with: cx with: c1))!

errorOnIntercept
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "

	^(sumXX / (sumXX * sum1 - sumX squared)) sqrt!

errorOnSlope
	"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 21/5/99 "

	^(sum1 / (sumXX * sum1 - sumX squared)) sqrt!

intercept
		"Answers the intercept of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	intercept isNil
		ifTrue: [ self computeResults].
	^intercept!

remove: aPoint 
	"Remove aPoint which was accumulated into of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := sum1 - 1.
	sumX := sumX - aPoint x.
	sumY := sumY - aPoint y.
	sumXX := sumXX - aPoint x squared.
	sumYY := sumYY - aPoint y squared.
	sumXY := sumXY - (aPoint x * aPoint y).
	self resetResults!

reset
	"Set all accumulators of the receiver to zero and reset its results.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "

	sum1 := 0.
	sumX := 0.
	sumY := 0.
	sumXX := 0.
	sumYY := 0.
	sumXY := 0.
	self resetResults!

resetResults
		"Private - Reset the results of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	slope := nil.
	intercept := nil.
	correlationCoefficient := nil.!

slope
		"Answers the slope of the receiver
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	slope isNil
		ifTrue: [ self computeResults].
	^slope!

value: aNumber
		"Answer the value interpolated at aNumber by the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^aNumber * self slope + self intercept! !
!DhbLinearRegression categoriesFor: #add:!public!transformation! !
!DhbLinearRegression categoriesFor: #add:weight:!public!transformation! !
!DhbLinearRegression categoriesFor: #asEstimatedPolynomial!information!public! !
!DhbLinearRegression categoriesFor: #asPolynomial!information!public! !
!DhbLinearRegression categoriesFor: #coefficients!information!public! !
!DhbLinearRegression categoriesFor: #computeResults!public!transformation! !
!DhbLinearRegression categoriesFor: #correlationCoefficient!information!public! !
!DhbLinearRegression categoriesFor: #errorMatrix!information!public! !
!DhbLinearRegression categoriesFor: #errorOnIntercept!information!public! !
!DhbLinearRegression categoriesFor: #errorOnSlope!information!public! !
!DhbLinearRegression categoriesFor: #intercept!information!public! !
!DhbLinearRegression categoriesFor: #remove:!public!transformation! !
!DhbLinearRegression categoriesFor: #reset!public!transformation! !
!DhbLinearRegression categoriesFor: #resetResults!public!transformation! !
!DhbLinearRegression categoriesFor: #slope!information!public! !
!DhbLinearRegression categoriesFor: #value:!information!public! !

!DhbLinearRegression class methodsFor!

new
		"Create a new instance of the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^( super new) reset; yourself! !
!DhbLinearRegression class categoriesFor: #new!creation!public! !

