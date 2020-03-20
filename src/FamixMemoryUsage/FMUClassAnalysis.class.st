"
I compute the memory used by all instances of a given class in a given model.
"
Class {
	#name : #FMUClassAnalysis,
	#superclass : #Object,
	#instVars : [
		'theClass',
		'instanceSize',
		'famixModel'
	],
	#category : #FamixMemoryUsage
}

{ #category : #'instance creation' }
FMUClassAnalysis class >> on: aClass [
	^self new on: aClass ; yourself
]

{ #category : #'instance creation' }
FMUClassAnalysis class >> on: aClass inModel: aModel [
	^self new on: aClass inModel: aModel ; yourself
]

{ #category : #metrics }
FMUClassAnalysis >> allInstancesInModel [
	^self instancesInModel: famixModel
]

{ #category : #introspection }
FMUClassAnalysis >> className [ 
	^ theClass name
]

{ #category : #'instance creation' }
FMUClassAnalysis >> collectPrivateStateProperties [
	^self allInstancesInModel flatCollectAsSet: [ :instance |
		self collectPrivateStateProperties: instance
	]
]

{ #category : #'instance creation' }
FMUClassAnalysis >> collectPrivateStateProperties: instance [
	"collect all attributes in privateState that are famix properties
	 Note: attributes are associations key->value"
	^instance privateState attributes
		collect: #key
		thenSelect: [ :symbol |
			self isFamixProperty: symbol
		].
]

{ #category : #'instance creation' }
FMUClassAnalysis >> computeInstanceSize [
	| instVar privateStateProperties |
	instVar := theClass allInstVarNames select: [ :symbol | self isFamixProperty: symbol ].
	privateStateProperties := self collectPrivateStateProperties.
	^(instVar size + privateStateProperties size) * Smalltalk wordSize

]

{ #category : #metrics }
FMUClassAnalysis >> instanceCount [
	^ self allInstancesInModel size
]

{ #category : #introspection }
FMUClassAnalysis >> instanceSize [
	^ instanceSize
]

{ #category : #metrics }
FMUClassAnalysis >> instancesInModel: aModel [
	^ aModel allWithType: theClass
]

{ #category : #'instance creation' }
FMUClassAnalysis >> isFamixProperty: aSymbol [
	"aSymbol is a famix property if there is a (getter) method with the same name
	 and the method as a pragma MSEProperty:type:[opposite:]"
	^(theClass lookupSelector: aSymbol)
		ifNil: [ false ]
		ifNotNil: [ :compiledMethod |
			compiledMethod pragmas anySatisfy: [:pragma |
				pragma keyword asString beginsWith: 'MSEProperty:type:']
		]
]

{ #category : #'instance creation' }
FMUClassAnalysis >> on: aClass inModel: aFamixModel [
	theClass := aClass.
	famixModel := aFamixModel.
	instanceSize := self computeInstanceSize
]

{ #category : #metrics }
FMUClassAnalysis >> totalMemory [
	^self instanceCount * self instanceSize
]
