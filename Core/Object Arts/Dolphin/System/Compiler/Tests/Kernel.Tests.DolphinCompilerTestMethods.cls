"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.Tests.DolphinCompilerTestMethods'
	instanceVariableNames: 'iv1 iv2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'Const' -> 16r1 }!
Kernel.Tests.DolphinCompilerTestMethods guid: (Core.GUID fromString: '{c6d8841d-910d-434f-9fec-9d821dd7a202}')!
Kernel.Tests.DolphinCompilerTestMethods comment: ''!
!Kernel.Tests.DolphinCompilerTestMethods categoriesForClass!Kernel-Objects! !
!Kernel.Tests.DolphinCompilerTestMethods methodsFor!

~~ x
	^super ~~ x!

== x
	^super == x!

appendToStream: puttableStream
	"Packed method with `Pop; Return Self` instruction"

	puttableStream nextPut: self!

associationAt: aString
	"Answer an <Association> with the specified key and the associated value from the receiver.
	If the key is not found, raise an exception."

	^(self associationAt: aString ifAbsent: nil)
		ifNil: [self errorKeyNotFound: aString]
		ifNotNil: [:assoc | assoc]!

basicSize
	^super basicSize!

ifNil: aNiladicValuable
	^super ifNil: [aNiladicValuable value]!

ifNil: aNiladicValuable ifNotNil: aMonadicValuable 
	^super ifNil: [aNiladicValuable value] ifNotNil: [:value | aMonadicValuable value: value]!

performOn: aProgramNode
	"Originally RBParseTreeRule>>performOn:. Has bytecode optimisation that leaves a voided text map entry for the ifTrue:"

	| ctx |
	ctx := self context.
	ctx empty.
	^((iv2 match: aProgramNode inContext: ctx) and: [self canMatch: aProgramNode])
		ifTrue: 
			[iv1 recusivelySearchInContext.
			self foundMatchFor: aProgramNode]
		ifFalse: [nil]!

testBlockWithAllTempTypes
	| sharedOuter copied local innerBlock |
	local := 0.
	copied := local + 2.
	sharedOuter := 1.
	
	^[:arg1 :arg2 | 
	| localBlock sharedBlock |
	sharedBlock := (arg1 + arg2) * sharedOuter * copied.
	sharedOuter := sharedOuter + 1.
	localBlock := sharedBlock * 10.
	innerBlock := 
			[sharedBlock := #abc.
			sharedOuter := sharedOuter * 10.
			sharedBlock].
	innerBlock.
	localBlock]!

testCleanBlockInCopyingBlock
	| a |
	a := #(1 2 3).
	^[a collect: [:each | each printString]]!

testCopyingBlockNestedInCleanBlock
	| a copyingBlock |
	a := 'abc'.
	copyingBlock := [:arg | [arg , arg reverse]] value: a.
	^copyingBlock!

testCopyingBlocks1
	| array |
	array := Array new.
	^array at: 1 ifAbsent: [1 > 2 ifTrue: ['bad bad bad'] ifFalse: [array]]!

testCopyingBlocks2
	| a |
	a := 'abc'.
	^[2 > 1 ifTrue: [a]] value!

testImmutableLiterals
	| bytes array string float scaledDecimal ints |
	bytes := #[1 2 3].
	array := #(1 'abc' #[1 2] 1.23 1.23s #(4)).
	string := 'abc'.
	float := 1.23.
	scaledDecimal := 1.23s.
	"Symbols not tested, as it is not the responsiblity of the compiler to make them immutable."
	ints := #(-16rFFFFFFFF -16r80000000 -16r7FFFFFFF -16r40000001 -16r80000000 16r40000000 16r7FFFFFFF 16r80000000 16rFFFFFFFF -16rFFFFFFFFFFFFFFFF -16r8000000000000000 -16r7FFFFFFFFFFFFFFF -16r4000000000000001 -16r8000000000000000 16r4000000000000000 16r7FFFFFFFFFFFFFFF 16r8000000000000000 16rFFFFFFFFFFFFFFFF).
	{ bytes. array. string. float. scaledDecimal. ints }!

testIncrementOptimisationMNU
	| i j |
	i := 'a'.
	i class.
	j := i + 1.
	5 class.
	^i, j printString!

testIncrementPushTempOptimisation
	| i j |
	i := 1.
	i class.
	j := i := i + 1.
	j class.
	^j!

testIncrementPushTempOptimisationFloat
	| i |
	i := 1.0.
	i class.
	i := i + 1.
	^i * 1!

testIncrementPushTempOptimisationLargeInt
	| i |
	i := 200 factorial.
	i class.
	i := i + 1.
	^i * 1!

testIncrementPushTempOptimisationLong
	| t1 t2 t3 t4 t5 t6 t7 j |
	t1 := t2 := t3 := t4 := t5 := t6 := t7 := 1.
	1 to: 5 do: [:i | j := i].
	^j!

testIncrementPushTempOptimisationMNU
	| i j |
	i := 'a'.
	i class.
	j := i := i + 1.
	j class.
	^j!

testIncrementPushTempOptimisationOverflow
	| i |
	i := SmallInteger maximum.
	i class.
	i := i + 1.
	^i * 1!

testIncrementTempOptimisation
	| i |
	i := 1.
	[i > 5] whileFalse: [i := i + 1].
	^i!

testIncrementTempOptimisationFloat
	| i |
	i := 1.0.
	i class.
	i := i + 1.
	5 class.
	^i!

testIncrementTempOptimisationLargeInt
	| i |
	i := 200 factorial.
	i class.
	i := i + 1.
	5 class.
	^i!

testIncrementTempOptimisationLong
	| t1 t2 t3 t4 t5 t6 t7 t8 i |
	t1 := t2 := t3 := t4 := t5 := t6 := t7 := t8 := 1.
	i := 1.
	[i > 5] whileFalse: [i := i + 1].
	^i!

testIncrementTempOptimisationMNU
	| i |
	i := 'a'.
	i class.
	i := i + 1.
	5 class.
	^i!

testIncrementTempOptimisationOverflow
	| i |
	i := SmallInteger maximum.
	i class.
	i := i + 1.
	5 class.
	^i!

testInfoHardBreakpoint
	self halt.
	^1 + 2!

testInfoHardBreakpointInBlock
	^
	[:x | 
	self halt.
	x * x]!

testInfoSupersendsOther
	super asParameter
	!

testInfoUnreferencedArgBlock
	^[:a | ]!

testInfoUnreferencedArgMethod: a 
	!

testInfoUnreferencedArgOptimizedBlock
	^1 ifNotNil: [:a | ]!

testMaximumBlockNesting
| t0 | t0 := 1. [|t1| t1 := 1. t0 := t1 := [|t2| t2 := 2. t0 := t2 := [|t3| t3 := 3. t0 := t3 := [|t4| t4 := 4. t0 := t4 := [|t5| t5 := 5. t0 := t5 := [|t6| t6 := 6. t0 := t6 := [|t7| t7 := 7. t0 := t7 := [|t8| t8 := 8. t0 := t8 := [|t9| t9 := 9. t0 := t9 := [|t10| t10 := 10. t0 := t10 := [|t11| t11 := 11. t0 := t11 := [|t12| t12 := 12. t0 := t12 := [|t13| t13 := 13. t0 := t13 := [|t14| t14 := 14. t0 := t14 := [|t15| t15 := 15. t0 := t15 := [|t16| t16 := 16. t0 := t16 := [|t17| t17 := 17. t0 := t17 := [|t18| t18 := 18. t0 := t18 := [|t19| t19 := 19. t0 := t19 := [|t20| t20 := 20. t0 := t20 := [|t21| t21 := 21. t0 := t21 := [|t22| t22 := 22. t0 := t22 := [|t23| t23 := 23. t0 := t23 := [|t24| t24 := 24. t0 := t24 := [|t25| t25 := 25. t0 := t25 := [|t26| t26 := 26. t0 := t26 := [|t27| t27 := 27. t0 := t27 := [|t28| t28 := 28. t0 := t28 := [|t29| t29 := 29. t0 := t29 := [|t30| t30 := 30. t0 := t30 := [|t31| t31 := 31. t0 := t31 := [|t32| t32 := 32. t0 := t32 := [|t33| t33 := 33. t0 := t33 := [|t34| t34 := 34. t0 := t34 := [|t35| t35 := 35. t0 := t35 := [|t36| t36 := 36. t0 := t36 := [|t37| t37 := 37. t0 := t37 := [|t38| t38 := 38. t0 := t38 := [|t39| t39 := 39. t0 := t39 := [|t40| t40 := 40. t0 := t40 := [|t41| t41 := 41. t0 := t41 := [|t42| t42 := 42. t0 := t42 := [|t43| t43 := 43. t0 := t43 := [|t44| t44 := 44. t0 := t44 := [|t45| t45 := 45. t0 := t45 := [|t46| t46 := 46. t0 := t46 := [|t47| t47 := 47. t0 := t47 := [|t48| t48 := 48. t0 := t48 := [|t49| t49 := 49. t0 := t49 := [|t50| t50 := 50. t0 := t50 := [|t51| t51 := 51. t0 := t51 := [|t52| t52 := 52. t0 := t52 := [|t53| t53 := 53. t0 := t53 := [|t54| t54 := 54. t0 := t54 := [|t55| t55 := 55. t0 := t55 := [|t56| t56 := 56. t0 := t56 := [|t57| t57 := 57. t0 := t57 := [|t58| t58 := 58. t0 := t58 := [|t59| t59 := 59. t0 := t59 := [|t60| t60 := 60. t0 := t60 := [|t61| t61 := 61. t0 := t61 := [|t62| t62 := 62. t0 := t62 := [|t63| t63 := 63. t0 := t63 := [|t64| t64 := 64. t0 := t64 := [|t65| t65 := 65. t0 := t65 := [|t66| t66 := 66. t0 := t66 := [|t67| t67 := 67. t0 := t67 := [|t68| t68 := 68. t0 := t68 := [|t69| t69 := 69. t0 := t69 := [|t70| t70 := 70. t0 := t70 := [|t71| t71 := 71. t0 := t71 := [|t72| t72 := 72. t0 := t72 := [|t73| t73 := 73. t0 := t73 := [|t74| t74 := 74. t0 := t74 := [|t75| t75 := 75. t0 := t75 := [|t76| t76 := 76. t0 := t76 := [|t77| t77 := 77. t0 := t77 := [|t78| t78 := 78. t0 := t78 := [|t79| t79 := 79. t0 := t79 := [|t80| t80 := 80. t0 := t80 := [|t81| t81 := 81. t0 := t81 := [|t82| t82 := 82. t0 := t82 := [|t83| t83 := 83. t0 := t83 := [|t84| t84 := 84. t0 := t84 := [|t85| t85 := 85. t0 := t85 := [|t86| t86 := 86. t0 := t86 := [|t87| t87 := 87. t0 := t87 := [|t88| t88 := 88. t0 := t88 := [|t89| t89 := 89. t0 := t89 := [|t90| t90 := 90. t0 := t90 := [|t91| t91 := 91. t0 := t91 := [|t92| t92 := 92. t0 := t92 := [|t93| t93 := 93. t0 := t93 := [|t94| t94 := 94. t0 := t94 := [|t95| t95 := 95. t0 := t95 := [|t96| t96 := 96. t0 := t96 := [|t97| t97 := 97. t0 := t97 := [|t98| t98 := 98. t0 := t98 := [|t99| t99 := 99. t0 := t99 := [|t100| t100 := 100. t0 := t100 := [|t101| t101 := 101. t0 := t101 := [|t102| t102 := 102. t0 := t102 := [|t103| t103 := 103. t0 := t103 := [|t104| t104 := 104. t0 := t104 := [|t105| t105 := 105. t0 := t105 := [|t106| t106 := 106. t0 := t106 := [|t107| t107 := 107. t0 := t107 := [|t108| t108 := 108. t0 := t108 := [|t109| t109 := 109. t0 := t109 := [|t110| t110 := 110. t0 := t110 := [|t111| t111 := 111. t0 := t111 := [|t112| t112 := 112. t0 := t112 := [|t113| t113 := 113. t0 := t113 := [|t114| t114 := 114. t0 := t114 := [|t115| t115 := 115. t0 := t115 := [|t116| t116 := 116. t0 := t116 := [|t117| t117 := 117. t0 := t117 := [|t118| t118 := 118. t0 := t118 := [|t119| t119 := 119. t0 := t119 := [|t120| t120 := 120. t0 := t120 := [|t121| t121 := 121. t0 := t121 := [|t122| t122 := 122. t0 := t122 := [|t123| t123 := 123. t0 := t123 := [|t124| t124 := 124. t0 := t124 := [|t125| t125 := 125. t0 := t125 := [|t126| t126 := 126. t0 := t126 := [|t127| t127 := 127. t0 := t127 := [|t128| t128 := 128. t0 := t128 := [|t129| t129 := 129. t0 := t129 := [|t130| t130 := 130. t0 := t130 := [|t131| t131 := 131. t0 := t131 := [|t132| t132 := 132. t0 := t132 := [|t133| t133 := 133. t0 := t133 := [|t134| t134 := 134. t0 := t134 := [|t135| t135 := 135. t0 := t135 := [|t136| t136 := 136. t0 := t136 := [|t137| t137 := 137. t0 := t137 := [|t138| t138 := 138. t0 := t138 := [|t139| t139 := 139. t0 := t139 := [|t140| t140 := 140. t0 := t140 := [|t141| t141 := 141. t0 := t141 := [|t142| t142 := 142. t0 := t142 := [|t143| t143 := 143. t0 := t143 := [|t144| t144 := 144. t0 := t144 := [|t145| t145 := 145. t0 := t145 := [|t146| t146 := 146. t0 := t146 := [|t147| t147 := 147. t0 := t147 := [|t148| t148 := 148. t0 := t148 := [|t149| t149 := 149. t0 := t149 := [|t150| t150 := 150. t0 := t150 := [|t151| t151 := 151. t0 := t151 := [|t152| t152 := 152. t0 := t152 := [|t153| t153 := 153. t0 := t153 := [|t154| t154 := 154. t0 := t154 := [|t155| t155 := 155. t0 := t155 := [|t156| t156 := 156. t0 := t156 := [|t157| t157 := 157. t0 := t157 := [|t158| t158 := 158. t0 := t158 := [|t159| t159 := 159. t0 := t159 := [|t160| t160 := 160. t0 := t160 := [|t161| t161 := 161. t0 := t161 := [|t162| t162 := 162. t0 := t162 := [|t163| t163 := 163. t0 := t163 := [|t164| t164 := 164. t0 := t164 := [|t165| t165 := 165. t0 := t165 := [|t166| t166 := 166. t0 := t166 := [|t167| t167 := 167. t0 := t167 := [|t168| t168 := 168. t0 := t168 := [|t169| t169 := 169. t0 := t169 := [|t170| t170 := 170. t0 := t170 := [|t171| t171 := 171. t0 := t171 := [|t172| t172 := 172. t0 := t172 := [|t173| t173 := 173. t0 := t173 := [|t174| t174 := 174. t0 := t174 := [|t175| t175 := 175. t0 := t175 := [|t176| t176 := 176. t0 := t176 := [|t177| t177 := 177. t0 := t177 := [|t178| t178 := 178. t0 := t178 := [|t179| t179 := 179. t0 := t179 := [|t180| t180 := 180. t0 := t180 := [|t181| t181 := 181. t0 := t181 := [|t182| t182 := 182. t0 := t182 := [|t183| t183 := 183. t0 := t183 := [|t184| t184 := 184. t0 := t184 := [|t185| t185 := 185. t0 := t185 := [|t186| t186 := 186. t0 := t186 := [|t187| t187 := 187. t0 := t187 := [|t188| t188 := 188. t0 := t188 := [|t189| t189 := 189. t0 := t189 := [|t190| t190 := 190. t0 := t190 := [|t191| t191 := 191. t0 := t191 := [|t192| t192 := 192. t0 := t192 := [|t193| t193 := 193. t0 := t193 := [|t194| t194 := 194. t0 := t194 := [|t195| t195 := 195. t0 := t195 := [|t196| t196 := 196. t0 := t196 := [|t197| t197 := 197. t0 := t197 := [|t198| t198 := 198. t0 := t198 := [|t199| t199 := 199. t0 := t199 := [|t200| t200 := 200. t0 := t200 := [|t201| t201 := 201. t0 := t201 := [|t202| t202 := 202. t0 := t202 := [|t203| t203 := 203. t0 := t203 := [|t204| t204 := 204. t0 := t204 := [|t205| t205 := 205. t0 := t205 := [|t206| t206 := 206. t0 := t206 := [|t207| t207 := 207. t0 := t207 := [|t208| t208 := 208. t0 := t208 := [|t209| t209 := 209. t0 := t209 := [|t210| t210 := 210. t0 := t210 := [|t211| t211 := 211. t0 := t211 := [|t212| t212 := 212. t0 := t212 := [|t213| t213 := 213. t0 := t213 := [|t214| t214 := 214. t0 := t214 := [|t215| t215 := 215. t0 := t215 := [|t216| t216 := 216. t0 := t216 := [|t217| t217 := 217. t0 := t217 := [|t218| t218 := 218. t0 := t218 := [|t219| t219 := 219. t0 := t219 := [|t220| t220 := 220. t0 := t220 := [|t221| t221 := 221. t0 := t221 := [|t222| t222 := 222. t0 := t222 := [|t223| t223 := 223. t0 := t223 := [|t224| t224 := 224. t0 := t224 := [|t225| t225 := 225. t0 := t225 := [|t226| t226 := 226. t0 := t226 := [|t227| t227 := 227. t0 := t227 := [|t228| t228 := 228. t0 := t228 := [|t229| t229 := 229. t0 := t229 := [|t230| t230 := 230. t0 := t230 := [|t231| t231 := 231. t0 := t231 := [|t232| t232 := 232. t0 := t232 := [|t233| t233 := 233. t0 := t233 := [|t234| t234 := 234. t0 := t234 := [|t235| t235 := 235. t0 := t235 := [|t236| t236 := 236. t0 := t236 := [|t237| t237 := 237. t0 := t237 := [|t238| t238 := 238. t0 := t238 := [|t239| t239 := 239. t0 := t239 := [|t240| t240 := 240. t0 := t240 := [|t241| t241 := 241. t0 := t241 := [|t242| t242 := 242. t0 := t242 := [|t243| t243 := 243. t0 := t243 := [|t244| t244 := 244. t0 := t244 := [|t245| t245 := 245. t0 := t245 := [|t246| t246 := 246. t0 := t246 := [|t247| t247 := 247. t0 := t247 := [|t248| t248 := 248. t0 := t248 := [|t249| t249 := 249. t0 := t249 := [|t250| t250 := 250. t0 := t250 := [|t251| t251 := 251. t0 := t251 := [|t252| t252 := 252. t0 := t252 := [|t253| t253 := 253. t0 := t253 := [|t254| t254 := 254. t0 := t254 := [|t255| t255 := 255. t0 := t255 := 256 ifNotNil: [:t256 | t0*(t1:= t1*1)*(t2:= t2*1)*(t3:= t3*1)*(t4:= t4*1)*(t5:= t5*1)*(t6:= t6*1)*(t7:= t7*1)*(t8:= t8*1)*(t9:= t9*1)*(t10:= t10*1)*(t11:= t11*1)*(t12:= t12*1)*(t13:= t13*1)*(t14:= t14*1)*(t15:= t15*1)*(t16:= t16*1)*(t17:= t17*1)*(t18:= t18*1)*(t19:= t19*1)*(t20:= t20*1)*(t21:= t21*1)*(t22:= t22*1)*(t23:= t23*1)*(t24:= t24*1)*(t25:= t25*1)*(t26:= t26*1)*(t27:= t27*1)*(t28:= t28*1)*(t29:= t29*1)*(t30:= t30*1)*(t31:= t31*1)*(t32:= t32*1)*(t33:= t33*1)*(t34:= t34*1)*(t35:= t35*1)*(t36:= t36*1)*(t37:= t37*1)*(t38:= t38*1)*(t39:= t39*1)*(t40:= t40*1)*(t41:= t41*1)*(t42:= t42*1)*(t43:= t43*1)*(t44:= t44*1)*(t45:= t45*1)*(t46:= t46*1)*(t47:= t47*1)*(t48:= t48*1)*(t49:= t49*1)*(t50:= t50*1)*(t51:= t51*1)*(t52:= t52*1)*(t53:= t53*1)*(t54:= t54*1)*(t55:= t55*1)*(t56:= t56*1)*(t57:= t57*1)*(t58:= t58*1)*(t59:= t59*1)*(t60:= t60*1)*(t61:= t61*1)*(t62:= t62*1)*(t63:= t63*1)*(t64:= t64*1)*(t65:= t65*1)*(t66:= t66*1)*(t67:= t67*1)*(t68:= t68*1)*(t69:= t69*1)*(t70:= t70*1)*(t71:= t71*1)*(t72:= t72*1)*(t73:= t73*1)*(t74:= t74*1)*(t75:= t75*1)*(t76:= t76*1)*(t77:= t77*1)*(t78:= t78*1)*(t79:= t79*1)*(t80:= t80*1)*(t81:= t81*1)*(t82:= t82*1)*(t83:= t83*1)*(t84:= t84*1)*(t85:= t85*1)*(t86:= t86*1)*(t87:= t87*1)*(t88:= t88*1)*(t89:= t89*1)*(t90:= t90*1)*(t91:= t91*1)*(t92:= t92*1)*(t93:= t93*1)*(t94:= t94*1)*(t95:= t95*1)*(t96:= t96*1)*(t97:= t97*1)*(t98:= t98*1)*(t99:= t99*1)*(t100:= t100*1)*(t101:= t101*1)*(t102:= t102*1)*(t103:= t103*1)*(t104:= t104*1)*(t105:= t105*1)*(t106:= t106*1)*(t107:= t107*1)*(t108:= t108*1)*(t109:= t109*1)*(t110:= t110*1)*(t111:= t111*1)*(t112:= t112*1)*(t113:= t113*1)*(t114:= t114*1)*(t115:= t115*1)*(t116:= t116*1)*(t117:= t117*1)*(t118:= t118*1)*(t119:= t119*1)*(t120:= t120*1)*(t121:= t121*1)*(t122:= t122*1)*(t123:= t123*1)*(t124:= t124*1)*(t125:= t125*1)*(t126:= t126*1)*(t127:= t127*1)*(t128:= t128*1)*(t129:= t129*1)*(t130:= t130*1)*(t131:= t131*1)*(t132:= t132*1)*(t133:= t133*1)*(t134:= t134*1)*(t135:= t135*1)*(t136:= t136*1)*(t137:= t137*1)*(t138:= t138*1)*(t139:= t139*1)*(t140:= t140*1)*(t141:= t141*1)*(t142:= t142*1)*(t143:= t143*1)*(t144:= t144*1)*(t145:= t145*1)*(t146:= t146*1)*(t147:= t147*1)*(t148:= t148*1)*(t149:= t149*1)*(t150:= t150*1)*(t151:= t151*1)*(t152:= t152*1)*(t153:= t153*1)*(t154:= t154*1)*(t155:= t155*1)*(t156:= t156*1)*(t157:= t157*1)*(t158:= t158*1)*(t159:= t159*1)*(t160:= t160*1)*(t161:= t161*1)*(t162:= t162*1)*(t163:= t163*1)*(t164:= t164*1)*(t165:= t165*1)*(t166:= t166*1)*(t167:= t167*1)*(t168:= t168*1)*(t169:= t169*1)*(t170:= t170*1)*(t171:= t171*1)*(t172:= t172*1)*(t173:= t173*1)*(t174:= t174*1)*(t175:= t175*1)*(t176:= t176*1)*(t177:= t177*1)*(t178:= t178*1)*(t179:= t179*1)*(t180:= t180*1)*(t181:= t181*1)*(t182:= t182*1)*(t183:= t183*1)*(t184:= t184*1)*(t185:= t185*1)*(t186:= t186*1)*(t187:= t187*1)*(t188:= t188*1)*(t189:= t189*1)*(t190:= t190*1)*(t191:= t191*1)*(t192:= t192*1)*(t193:= t193*1)*(t194:= t194*1)*(t195:= t195*1)*(t196:= t196*1)*(t197:= t197*1)*(t198:= t198*1)*(t199:= t199*1)*(t200:= t200*1)*(t201:= t201*1)*(t202:= t202*1)*(t203:= t203*1)*(t204:= t204*1)*(t205:= t205*1)*(t206:= t206*1)*(t207:= t207*1)*(t208:= t208*1)*(t209:= t209*1)*(t210:= t210*1)*(t211:= t211*1)*(t212:= t212*1)*(t213:= t213*1)*(t214:= t214*1)*(t215:= t215*1)*(t216:= t216*1)*(t217:= t217*1)*(t218:= t218*1)*(t219:= t219*1)*(t220:= t220*1)*(t221:= t221*1)*(t222:= t222*1)*(t223:= t223*1)*(t224:= t224*1)*(t225:= t225*1)*(t226:= t226*1)*(t227:= t227*1)*(t228:= t228*1)*(t229:= t229*1)*(t230:= t230*1)*(t231:= t231*1)*(t232:= t232*1)*(t233:= t233*1)*(t234:= t234*1)*(t235:= t235*1)*(t236:= t236*1)*(t237:= t237*1)*(t238:= t238*1)*(t239:= t239*1)*(t240:= t240*1)*(t241:= t241*1)*(t242:= t242*1)*(t243:= t243*1)*(t244:= t244*1)*(t245:= t245*1)*(t246:= t246*1)*(t247:= t247*1)*(t248:= t248*1)*(t249:= t249*1)*(t250:= t250*1)*(t251:= t251*1)*(t252:= t252*1)*(t253:= t253*1)*(t254:= t254*1)*(t255:= t255*1)*t256]] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value] value!

testNestedCopyingBlocks
	| a |
	a := 'abc'.
	^
	[a , a.
	[a].
	[a , a]]!

testNestedWhileTrueAtStartOfCleanBlock
	"Nested optimized blocks where the block occurs before the message are a tricky case
	for the compiler"

	^[[#() notEmpty] whileTrue]!

testOverriddenBlockArgumentWarning
	"The innermost block is copying (since it closes over 'a' after it is last assigned), but should
	 close over the temp 'a', rather than the argument 'a'"

	^
	[:a | 
	
	[| a |
	a := 2.
	[a]]]!

testOverriddenMethodArgumentWarning: a 
	"The block should copy the temp value rather than that of the arg"

	^
	[| a |
	a := 2.
	[a]]!

testReturnFromOptimizedBlock
	^
	[1 > 2 ifTrue: [^1] ifFalse: [[^self]].
	2 < 1] 
			whileTrue: [1 > 2 ifTrue: [^nil] ifFalse: [[^self] value]]!

testSharedOuterTemps1
	| a |
	a := [[a := 2]].
	^a!

testSharedOuterTemps2
	| a b |
	b := [[a]].
	a := 2.
	^b!

testTempsMapInlinedReturn
	^self ifTrue: [self] ifFalse: [self printString]!

testTempsMapNestedFullBlocks
	"See github issue #134"

	"Original example from issue"

	#(1 2) do: 
			[:each |
			| a |
			[
			[self halt.
			a := 'AAA'] on: Error do: [:ex | ]] ensure: []].

	"Simple nested full block"
	
	[| a |
	[a := 1] value.
	a] value!

testTempsMapNestedFullInOptimized
	iv1 isNil
		ifFalse: 
			[| first |
			first := true.
			iv1 do: 
					[:each |
					first ifTrue: [first := false] ifFalse: [Transcript space].
					Transcript print: each]]!

testTempsMapOuterTempsIssue304
	| env |
	env := 0.
	#(#foo #bar #baz) keysAndValuesDo: 
			[:i :argOuter |
			| env2 |
			env2 := i.
			false
				ifFalse: 
					[#(1 2 3 4 5) do: 
							[:argInner |
							env2 := env2 + 1.
							env := env + env2]]]!

testWarningCantOptimizeLoop

	1 whileTrue.
	2 whileFalse.
	3 repeat.
	[:a | ] whileTrue. 
	[:b | ] whileFalse. 
	[:c | ] repeat.
	!

testWarningMutableIgnored
	<mutable>
	^1!

testWarningReadBeforeWrittenBlockTemp
	
	[| _tmp |
	_tmp := "@"_tmp"@" ifTrue: [1] ifFalse: [2]]!

testWarningReadBeforeWrittenFullBlock
	| _tmp |
	_tmp := [:i | i > 1 ifTrue: [i * ("@"_tmp"@" value: i - 1)] ifFalse: [1]]!

testWarningReadBeforeWrittenMethodTemp
	| _tmp |
	"@"_tmp"@" ifTrue: [^1].
	_tmp := 2.
	^_tmp!

testWarningReadNotWrittenBlockTemp
	
	[| "$"_tmp"$" |
	"@"_tmp"@" ifTrue: [1] ifFalse: [2]]!

testWarningReadNotWrittenMethodTemp
	| "$"_tmp"$" |
	"@"_tmp"@" ifTrue: [^1]!

testWarningReadNotWrittenOptimizedBlockTemp
	1 to: 5 do: [:each |
		| "$"_tmp"$" |
		"@"_tmp"@" ifTrue: [^each]]!

testWarningRedefiningArgInOptimizedBlock: a 
	a = 1 
		ifTrue: 
			[| a |
			a := 2. 
			a].
	a!

testWarningRedefiningBlockArgInBlock
	^[:a | 
	[:b |
	| a |
	a := 2.
	a + b] value: a]!

testWarningRedefiningInstVarAsArg: iv1
	^iv1!

testWarningRedefiningInstVarAsBlockArg
	^
	[:iv1 | iv1 * iv1]!

testWarningRedefiningInstVarAsBlockTemp
	| a |
	a := 
			[| iv1 |
			iv1 := 2.
			^iv1].
	^a value!

testWarningRedefiningInstVarAsOptimizedBlockArg
	^iv2 a ifNotNil: [:iv1 | iv1 * iv1]!

testWarningRedefiningInstVarAsOptimizedBlockTemp
	| a |
	a := 1.
	a = 1 
		ifTrue: 
			[| iv1 |
			iv1 := 2.
			^iv1].
	^iv1!

testWarningRedefiningInstVarAsTemp
	| iv1 |
	iv1 := 2.
	^iv1!

testWarningRedefiningMethodArgInBlock: a 
	[| a |
	a := 2.
	a] value.
	^a!

testWarningRedefiningStaticAsArg: Object 
	^Object!

testWarningRedefiningStaticAsBlockArg
	^[:Object | Object]!

testWarningRedefiningStaticAsBlockTemp
	^
	[| Object |
	Object := 5.
	Object - 4]!

testWarningRedefiningStaticAsBlockTemp: ab x: b
	^
	[:ab | | Object a  |
	Object := 5. 
	Object - 4]!

testWarningRedefiningStaticAsTemp
	| Object |
	Object := 1.
	^Object
	!

testWarningUnreachable
	^self.
	1 + 2.
	2 + 3!

testWarningUnreferencedTempBlock
	
	[| c a b |
	b := c := 1.
	b + c]!

testWarningUnreferencedTempBraceArray
	| c a b |
	^{b := c := 1. b + c}!

testWarningUnreferencedTempMethod
	| c a b |
	b := c := 1.
	^b + c!

testWarningUnreferencedTempOptimizedBlock
	self isBehavior 
		ifTrue: 
			[| c a b |
			b := c := 1.
			b + c]!

testWarningUsesFalse
	self = false.
	self = False!

testWarningUsesTrue
	self = true.
	self = True!

testWarningWrittenNotReadBlockTemp
	
	^[| _tmp |
	_tmp := 1]!

testWarningWrittenNotReadBraceArray
	| tmp1 _tmp |
	tmp1 := 1.
	_tmp := 2.
	^{ tmp1 }
!

testWarningWrittenNotReadFullBlock
	| _tmp |
	^[_tmp := 1]!

testWarningWrittenNotReadMethodTemp
	| _tmp |
	_tmp := 1.
!

testWarnMsgUnimplementedByConst
	1 asParameter.
	"A dynamic selector"
	MSGBOXPARAMSW new dwLanguageId: 1234.
	Const wibblyWobblySillySelectorThatNoOneCouldPossiblyImplementIHope.
	self asParameter!

testWarnMsgUnimplementedByNil
	1 asParameter.
	nil wibblyWobblySillySelectorThatNoOneCouldPossiblyImplementIHope.
	self asParameter!

testWarnMsgUnimplementedBySelf
	1 asParameter.
	self wibblyWobblySillySelectorThatNoOneCouldPossiblyImplementIHope.
	self asParameter!

testWarnMsgUnimplementedBySuper
	1 asParameter.
	super testWarnMsgUnimplementedBySuper.
	self asParameter!

testWarnNiladicExceptionHandler
	"Warning not issued unless literal block passed as arg"
	| handler |
	handler := [].
	[1 + 2] 
		on: Error
		do: handler
		on: StackOverflow
		do: 
			["Deprecated form of handler block with no argument"
			]!

testWarnNonNiladicGuardedBlock
	"Warning not issued unless receiver is literal block "

	| guarded |
	guarded := [:a :b | a + b].
	guarded on: Error do: [:x | x return].
	">"[:a :b | a + b]"<" on: Error do: [:x | x exit]!

testWarnUndefinedSelector
	1 asParameter.
	self asValue wibblyWobblySillySelectorThatNoOneCouldPossiblyImplementIHope.
	self asParameter!

testWarnUnimplementedAbstractMethod
	^self subclassResponsibility! !
!Kernel.Tests.DolphinCompilerTestMethods categoriesForMethods!
~~!public!unit tests! !
==!public!unit tests! !
appendToStream:!public!unit tests! !
associationAt:!accessing!public! !
basicSize!public!unit tests! !
ifNil:!public!unit tests! !
ifNil:ifNotNil:!public!unit tests! !
performOn:!matching!public! !
testBlockWithAllTempTypes!public!unit tests! !
testCleanBlockInCopyingBlock!public!unit tests! !
testCopyingBlockNestedInCleanBlock!public!unit tests! !
testCopyingBlocks1!public!unit tests! !
testCopyingBlocks2!public!unit tests! !
testImmutableLiterals!public!unit tests! !
testIncrementOptimisationMNU!public!unit tests! !
testIncrementPushTempOptimisation!public!unit tests! !
testIncrementPushTempOptimisationFloat!public!unit tests! !
testIncrementPushTempOptimisationLargeInt!public!unit tests! !
testIncrementPushTempOptimisationLong!public!unit tests! !
testIncrementPushTempOptimisationMNU!public!unit tests! !
testIncrementPushTempOptimisationOverflow!public!unit tests! !
testIncrementTempOptimisation!public!unit tests! !
testIncrementTempOptimisationFloat!public!unit tests! !
testIncrementTempOptimisationLargeInt!public!unit tests! !
testIncrementTempOptimisationLong!public!unit tests! !
testIncrementTempOptimisationMNU!public!unit tests! !
testIncrementTempOptimisationOverflow!public!unit tests! !
testInfoHardBreakpoint!public!unit tests! !
testInfoHardBreakpointInBlock!public!unit tests! !
testInfoSupersendsOther!public!unit tests! !
testInfoUnreferencedArgBlock!public!unit tests! !
testInfoUnreferencedArgMethod:!public!unit tests! !
testInfoUnreferencedArgOptimizedBlock!public!unit tests! !
testMaximumBlockNesting!public!unit tests! !
testNestedCopyingBlocks!public!unit tests! !
testNestedWhileTrueAtStartOfCleanBlock!public!unit tests! !
testOverriddenBlockArgumentWarning!public!unit tests! !
testOverriddenMethodArgumentWarning:!public!unit tests! !
testReturnFromOptimizedBlock!public!unit tests! !
testSharedOuterTemps1!public!unit tests! !
testSharedOuterTemps2!public!unit tests! !
testTempsMapInlinedReturn!public!unit tests! !
testTempsMapNestedFullBlocks!public!unit tests! !
testTempsMapNestedFullInOptimized!public!unit tests! !
testTempsMapOuterTempsIssue304!public!unit tests! !
testWarningCantOptimizeLoop!public!unit tests! !
testWarningMutableIgnored!public!unit tests! !
testWarningReadBeforeWrittenBlockTemp!public!unit tests! !
testWarningReadBeforeWrittenFullBlock!public!unit tests! !
testWarningReadBeforeWrittenMethodTemp!public!unit tests! !
testWarningReadNotWrittenBlockTemp!public!unit tests! !
testWarningReadNotWrittenMethodTemp!public!unit tests! !
testWarningReadNotWrittenOptimizedBlockTemp!public!unit tests! !
testWarningRedefiningArgInOptimizedBlock:!public!unit tests! !
testWarningRedefiningBlockArgInBlock!public!unit tests! !
testWarningRedefiningInstVarAsArg:!public!unit tests! !
testWarningRedefiningInstVarAsBlockArg!public!unit tests! !
testWarningRedefiningInstVarAsBlockTemp!public!unit tests! !
testWarningRedefiningInstVarAsOptimizedBlockArg!public!unit tests! !
testWarningRedefiningInstVarAsOptimizedBlockTemp!public!unit tests! !
testWarningRedefiningInstVarAsTemp!public!unit tests! !
testWarningRedefiningMethodArgInBlock:!public!unit tests! !
testWarningRedefiningStaticAsArg:!public!unit tests! !
testWarningRedefiningStaticAsBlockArg!public!unit tests! !
testWarningRedefiningStaticAsBlockTemp!public!unit tests! !
testWarningRedefiningStaticAsBlockTemp:x:!public!unit tests! !
testWarningRedefiningStaticAsTemp!public!unit tests! !
testWarningUnreachable!public!unit tests! !
testWarningUnreferencedTempBlock!public!unit tests! !
testWarningUnreferencedTempBraceArray!public!unit tests! !
testWarningUnreferencedTempMethod!public!unit tests! !
testWarningUnreferencedTempOptimizedBlock!public!unit tests! !
testWarningUsesFalse!public!unit tests! !
testWarningUsesTrue!public!unit tests! !
testWarningWrittenNotReadBlockTemp!public!unit tests! !
testWarningWrittenNotReadBraceArray!public!unit tests! !
testWarningWrittenNotReadFullBlock!public!unit tests! !
testWarningWrittenNotReadMethodTemp!public!unit tests! !
testWarnMsgUnimplementedByConst!public!unit tests! !
testWarnMsgUnimplementedByNil!public!unit tests! !
testWarnMsgUnimplementedBySelf!public!unit tests! !
testWarnMsgUnimplementedBySuper!public!unit tests! !
testWarnNiladicExceptionHandler!public!unit tests! !
testWarnNonNiladicGuardedBlock!public!unit tests! !
testWarnUndefinedSelector!public!unit tests! !
testWarnUnimplementedAbstractMethod!public!unit tests! !
!

