"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Fbench
	instanceVariableNames: 'testcase paraxial radiusOfCurvature objectDistance rayHeight axisSlopeAngle fromIndex toIndex currentSurfaces clearAperture niter odSa odCline odFline aberrLspher aberrOsc aberrLchrom maxLspher maxOsc maxLchrom'
	classVariableNames: 'ALine BLine CLine DLine ELine FLine GprimeLine HLine spectralLine'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Fbench guid: (GUID fromString: '{47d6aa87-0382-4770-930e-eb112b33d638}')!
Fbench comment: 'John Walker''s Floating Point Benchmark'!
!Fbench categoriesForClass!Kernel-Objects! !
!Fbench methodsFor!

benchmark: iterations
	"  Run the benchmark for the number of iterations given by
           the argument and display the results of the last run for
           comparison against the expected results.  "

	| trun stdout |
	stdout := Transcript.
	niter := iterations.
	stdout
		display: 'Ready to begin John Walker''s floating point accuracy
and performance benchmark.  ';
		print: niter;
		display: ' iterations will be made.

Measured run time in seconds should be divided by ';
		display: (niter / 1000) rounded;
		cr;
		display: 'to normalise for reporting results.  For archival results,
adjust iteration count so the benchmark runs about five minutes.
';
		cr;
		flush.
	trun := Time microsecondsToRun: [self traceDesign].
	stdout
		display: 'Completed in ';
		display: trun;
		display: 'uS';
		cr;
		cr;
		display: 'Time per iteration: ';
		display: (trun / iterations toDecimal: 1 places: 2);
		display: ' uS.';
		cr;
		cr;
		display: '   Marginal ray        ';
		display: (((odSa at: 1) at: 1) toDecimal: 16 places: 11);
		display: (((odSa at: 1) at: 2) toDecimal: 16 places: 11);
		cr;
		display: '   Paraxial ray        ';
		display: (((odSa at: 2) at: 1) toDecimal: 16 places: 11);
		display: (((odSa at: 2) at: 2) toDecimal: 16 places: 11);
		cr;
		display: 'Longitudinal spherical aberration:      ';
		display: (aberrLspher toDecimal: 16 places: 11);
		cr;
		display: '    (Maximum permissible):              ';
		display: (maxLspher toDecimal: 16 places: 11);
		cr;
		display: 'Offense against sine condition (coma):  ';
		display: (aberrOsc toDecimal: 16 places: 11);
		cr;
		display: '    (Maximum permissible):              ';
		display: (maxOsc toDecimal: 16 places: 11);
		cr;
		display: 'Axial chromatic aberration:             ';
		display: (aberrLchrom toDecimal: 16 places: 11);
		cr;
		display: '    (Maximum permissible):              ';
		display: (maxLchrom toDecimal: 16 places: 11);
		cr;
		flush!

init
            niter := 1.             " Number of iterations "

            "  The test case used in this program is the design for a 4 inch
               f/12 achromatic telescope objective used as the example in Wyld's
               classic work on ray tracing by hand, given in Amateur Telescope
               Making, Volume 3 (Volume 2 in the 1996 reprint edition).  "

            "  The first index of the testcase array is the surface number.
               For each surface, its properties are given by the following
               array element:

                    1  Radius of curvature (+ if convex to light source)
                    2  Index of refraction (1 for air space)
                    3  Dispersion (Abbe number (V))
                    4  Edge thickness (0 for last surface)  "

            testcase := Array new: 4.
            testcase := #(
                (  27.05 1.5137 63.6 0.52  )
                ( -16.68 1.0     0.0 0.138 )
                ( -16.68 1.6164 36.7 0.38  )
                ( -78.1  1.0     0.0 0.0   )
            ).
            currentSurfaces := 4.
            clearAperture := 4.0.

            odSa := Array new: 2.
            odSa at: 1 put: (Array new: 2).
            odSa at: 2 put: (Array new: 2).

            "  Spectral line mnemonics  "

            ALine := 1.
            BLine := 2.
            CLine := 3.
            DLine := 4.
            ELine := 5.
            FLine := 6.
            GprimeLine := 7.
            HLine := 8.

            "  Wavelengths of standard spectral lines in Angstroms
                   (Not all are used in this program)  "

            spectralLine := Array new: 8.
            spectralLine := #(
                7621.0          " A "
                6869.955        " B "
                6562.816        " C "
                5895.944        " D "
                5269.557        " E "
                4861.344        " F "
                4340.477        " G' "
                3968.494        " H "
            ).

            paraxial := false.
        !

"  Ray trace the design given in testcase and analyse the results  "

        traceDesign
            1 to: niter do: [ :itercount |
                paraxial := false.

                " Do main trace in D light "

                1 to: 2 do: [ :axial |
                    self traceLine: DLine rayHeight: (clearAperture / 2).
                    (odSa at: axial) at: 1 put: objectDistance.
                    (odSa at: axial) at: 2 put: axisSlopeAngle.
                    paraxial := true.
                ].
                paraxial := false.

                " Trace marginal ray in C "

                self traceLine: CLine rayHeight: (clearAperture / 2).
                odCline := objectDistance.

                " Trace marginal ray in F "

                self traceLine: FLine rayHeight: (clearAperture / 2).
                odFline := objectDistance.

                aberrLspher := ((odSa at: 2) at: 1) - ((odSa at: 1) at: 1).
                aberrOsc := 1 - ((((odSa at: 2) at: 1) * ((odSa at: 2) at: 2)) /
                    ((((odSa at: 1) at: 2) sin) * ((odSa at: 1) at: 1))).
                aberrLchrom := odFline - odCline.
                maxLspher := ((odSa at: 1) at: 2) sin.

                " D light "

                maxLspher := 0.0000926 / (maxLspher squared).
                maxOsc := 0.0025.
                maxLchrom := maxLspher.
            ].
        !

"  Perform ray trace in specific spectral line  "

        traceLine: line rayHeight: rayH

            objectDistance := 0.0.
            rayHeight := rayH.
            fromIndex := 1.0.

            1 to: currentSurfaces do: [ :i |
                radiusOfCurvature := ((testcase at: i) at: 1).
                toIndex := ((testcase at: i) at: 2).

                (toIndex > 1.0) ifTrue: [
                    toIndex := toIndex + ((((spectralLine at: DLine) -
                        (spectralLine at: line)) /
                        ((spectralLine at: CLine) - (spectralLine at: FLine))) *
                        ((((testcase at: i) at: 2) - 1.0) / ((testcase at: i) at: 3))).
                ].
                self transitSurface.
                fromIndex := toIndex.
                (i < currentSurfaces) ifTrue: [
                    objectDistance := objectDistance - ((testcase at: i) at: 4).
                ]
            ].
        !

transitSurface
	"     Calculate passage through surface

              If the variable paraxial is true, the trace through the
              surface will be done using the paraxial approximations.
              Otherwise, the normal trigonometric trace will be done.

              This subroutine takes the following global inputs:

              radiusOfCurvature       Radius of curvature of surface
                                      being crossed.  If 0, surface is
                                      plane.

              objectDistance          Distance of object focus from
                                      lens vertex.  If 0, incoming
                                      rays are parallel and the
                                      following must be specified:

              rayHeight               Height of ray from axis.  Only
                                      relevant if objectDistance = 0

              axisSlopeAngle          Angle incoming ray makes with axis
                                      at intercept

              fromIndex               Refractive index of medium being left

              toIndex                 Refractive index of medium being
                                      entered

              The outputs are the following global variables:

              objectDistance          Distance from vertex to object focus
                                      after refraction.

              axisSlopeAngle          Angle incoming ray makes with axis
                                      at intercept after refraction. "

	| iang rang iangSin rangSin oldAxisSlopeAngle sagitta |
	"  Incidence angle       "

	"  Refraction angle      "

	"  Incidence angle sin   "

	"  Refraction angle sin  "
	paraxial
		ifTrue: 
			[radiusOfCurvature ~= 0
				ifTrue: 
					[objectDistance = 0
						ifTrue: 
							[axisSlopeAngle := 0.
							iangSin := rayHeight / radiusOfCurvature]
						ifFalse: [iangSin := (objectDistance - radiusOfCurvature) / radiusOfCurvature * axisSlopeAngle].
					rangSin := fromIndex / toIndex * iangSin.
					oldAxisSlopeAngle := axisSlopeAngle.
					axisSlopeAngle := axisSlopeAngle + (iangSin - rangSin).
					objectDistance ~= 0 ifTrue: [rayHeight := objectDistance * oldAxisSlopeAngle].
					objectDistance := rayHeight / axisSlopeAngle]
				ifFalse: 
					[objectDistance := objectDistance * (toIndex / fromIndex).
					axisSlopeAngle := axisSlopeAngle * (fromIndex / toIndex)]]
		ifFalse: 
			[radiusOfCurvature ~= 0.0
				ifTrue: 
					[objectDistance = 0
						ifTrue: 
							[axisSlopeAngle := 0.0.
							iangSin := rayHeight / radiusOfCurvature]
						ifFalse: [iangSin := (objectDistance - radiusOfCurvature) / radiusOfCurvature * axisSlopeAngle sin].
					iang := iangSin arcSin.
					rangSin := fromIndex / toIndex * iangSin.
					oldAxisSlopeAngle := axisSlopeAngle.
					axisSlopeAngle := axisSlopeAngle + iang - rangSin arcSin.
					sagitta := ((oldAxisSlopeAngle + iang) / 2.0) sin.
					sagitta := 2.0 * radiusOfCurvature * sagitta * sagitta.
					objectDistance := radiusOfCurvature * (oldAxisSlopeAngle + iang) sin * (1.0 / axisSlopeAngle tan)
								+ sagitta]
				ifFalse: 
					[rang := (fromIndex / toIndex * axisSlopeAngle sin) arcSin negated.
					objectDistance := objectDistance * (toIndex * rang negated cos / (fromIndex * axisSlopeAngle cos)).
					axisSlopeAngle := rang negated]]! !
!Fbench categoriesFor: #benchmark:!public! !
!Fbench categoriesFor: #init!public! !
!Fbench categoriesFor: #traceDesign!public!ray tracing! !
!Fbench categoriesFor: #traceLine:rayHeight:!public!ray tracing! !
!Fbench categoriesFor: #transitSurface!public!ray tracing! !

!Fbench class methodsFor!

new
            | r |
            r := super new.
            r init.
            ^r
        ! !
!Fbench class categoriesFor: #new!public! !

