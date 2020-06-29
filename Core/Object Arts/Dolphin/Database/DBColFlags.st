"Filed out from Dolphin Smalltalk 7"!

#{DBColFlags} declare: (PoolConstantsDictionary named: #DBColFlags)!
DBColFlags at: 'DeleteCascade' put: 16r10!
DBColFlags at: 'DeleteRestrict' put: 16r20!
DBColFlags at: 'DeleteRules' put: 16r70!
DBColFlags at: 'DeleteSetNull' put: 16r40!
DBColFlags at: 'ForeignKey' put: 16r2!
DBColFlags at: 'ParameterTypeMask' put: 16r3800!
DBColFlags at: 'ParameterTypeShift' put: 16rB!
DBColFlags at: 'PrimaryKey' put: 16r1!
DBColFlags at: 'UpdateCascade' put: 16r100!
DBColFlags at: 'UpdateRestrict' put: 16r200!
DBColFlags at: 'UpdateRules' put: 16r700!
DBColFlags at: 'UpdateSetNull' put: 16r400!
DBColFlags shrink!
