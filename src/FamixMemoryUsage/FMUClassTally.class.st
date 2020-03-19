Class {
	#name : #FMUClassTally,
	#superclass : #Object,
	#instVars : [
		'theClass',
		'instanceSize',
		'famixModel'
	],
	#category : #FamixMemoryUsage
}

{ #category : #'instance creation' }
FMUClassTally class >> on: aClass [
	^self new on: aClass ; yourself
]

{ #category : #'instance creation' }
FMUClassTally class >> on: aClass inModel: aModel [
	^self new on: aClass inModel: aModel ; yourself
]

{ #category : #introspection }
FMUClassTally >> className [ 
	^ theClass name
]

{ #category : #metrics }
FMUClassTally >> instanceCount [
	^ self instancesInModel: famixModel 
]

{ #category : #introspection }
FMUClassTally >> instanceSize [
	^ instanceSize
]

{ #category : #metrics }
FMUClassTally >> instancesInModel: aModel [
	^ (aModel allWithType: theClass) size
]

{ #category : #'instance creation' }
FMUClassTally >> on: aClass [ 
	theClass := aClass.
	instanceSize := (aClass instancesSizeInMemory) / (aClass allInstances size)
]

{ #category : #'instance creation' }
FMUClassTally >> on: aClass inModel: aFamixModel [
	theClass := aClass.
	famixModel := aFamixModel.
	instanceSize := (aClass instancesSizeInMemory) / (aClass allInstances size)
]

{ #category : #metrics }
FMUClassTally >> totalMemory [
	^self instanceCount * self instanceSize 
]
