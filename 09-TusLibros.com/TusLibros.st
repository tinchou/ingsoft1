!classDefinition: #CartTest category: #TusLibros!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'testing' stamp: 'MC 6/4/2018 21:43:55'!
test01_emptyCartHasNoItems
	| catalog cart |
	catalog _ Set new.
	cart _ Cart forCatalog: catalog.
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/4/2018 21:48:05'!
test02_cartCanHoldItemInCatalog
	| catalog cart |
	catalog _ Set with: 'a book'.
	cart _ Cart forCatalog: catalog.
	cart add: 'a book'.
	self assert: (cart includes: 'a book').! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/4/2018 21:47:57'!
test03_cartCannotHoldItemNotInCatalog
	| catalog cart |
	catalog _ Set new.
	cart _ Cart forCatalog: catalog.
	self
		should: [ cart add: 'a book' ]
		raise: Error - MessageNotUnderstood
		withMessageText: Cart bookNotInCatalogMessage.
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/4/2018 21:47:49'!
test04_cartCanHoldDifferentItems
	| catalog cart |
	catalog _ Set
		with: 'a book'
		with: 'another book'.
	cart _ Cart forCatalog: catalog.
	cart add: 'a book'.
	cart add: 'another book'.
	self assert: (cart includes: 'a book').
	self assert: (cart includes: 'another book').! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:08:05'!
test05_cartCanHoldTheSameItemMultipleTimes
	| catalog cart |
	catalog _ Set
		with: 'a book'.
	cart _ Cart forCatalog: catalog.
	cart add: 'a book' quantity: 3.
	self assert: (cart includes: 'a book').
	self assert: 3 equals: (cart quantityFor: 'a book').! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:03:20'!
test06_cartCannotHoldLessThanOneOfAnItem
	| catalog cart |
	catalog _ Set
		with: 'a book'.
	cart _ Cart forCatalog: catalog.
	self
		should: [ cart add: 'a book' quantity: 0 ]
		raise: Error - MessageNotUnderstood
		withMessageText: Cart itemQuantityShouldBeOneOrMore.
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:07:42'!
test07_cartReturnsQuantityZeroForItemsNotPresent
	| catalog cart |
	catalog _ Set
		with: 'a book'.
	cart _ Cart forCatalog: catalog.
	self assert: 0 equals: (cart quantityFor: 'a book').! !

!CartTest methodsFor: 'testing' stamp: 'JA 6/7/2018 20:30:18'!
test08_cartCannotHoldNonIntegerQuantitiesOfAnItem
	| catalog cart |
	catalog _ Set
		with: 'a book'.
	cart _ Cart forCatalog: catalog.
	self
		should: [ cart add: 'a book' quantity: 1.5 ]
		raise: Error - MessageNotUnderstood
		withMessageText: Cart itemQuantityShouldBeAnInteger.
	self assert: cart isEmpty.! !


!classDefinition: #MarketTest category: #TusLibros!
TestCase subclass: #MarketTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MarketTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:19:22'!
test01_marketCanGiveKnownUserANewCart
	| catalog market users |
	users _ Set with: 'a user'.
	catalog _ Set new.
	market _ Market forUsers: users buyingFromCatalog: catalog.
	self assert: (market newCartFor: 'a user') isEmpty.! !

!MarketTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:25:03'!
test02_userCanAddItemFromCatalogToMarketsCart
	| catalog market users cart |
	users _ Set with: 'a user'.
	catalog _ Set with: 'a book'.
	market _ Market forUsers: users buyingFromCatalog: catalog.
	cart _ market newCartFor: 'a user'.
	cart add: 'a book'.
	self assert: (cart includes: 'a book').! !

!MarketTest methodsFor: 'testing' stamp: 'MC 6/6/2018 19:29:27'!
test03_marketCannotGiveUnknownUserANewCart
	| catalog market users |
	users _ Set new.
	catalog _ Set new.
	market _ Market forUsers: users buyingFromCatalog: catalog.
	self
		should: [ market newCartFor: 'a user' ]
		raise: Error - MessageNotUnderstood
		withMessageText: Market userNotKnown.! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'items catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'item management' stamp: 'MC 6/4/2018 21:57:53'!
add: anItem
	self add: anItem quantity: 1.! !

!Cart methodsFor: 'item management' stamp: 'JA 6/7/2018 20:29:13'!
add: anItem quantity: quantity
	(catalog includes: anItem) ifFalse: [
		self error: self class bookNotInCatalogMessage.
	].
	(quantity > 0) ifFalse: [
		self error: self class itemQuantityShouldBeOneOrMore.
	].
	(quantity isInteger) ifFalse: [
		self error: self class itemQuantityShouldBeAnInteger.
	].
	items add: anItem withOccurrences: quantity.! !


!Cart methodsFor: 'initialization' stamp: 'JA 6/7/2018 20:21:57'!
initializeFor: aCatalog
	catalog _ aCatalog.
	items _ Bag new.! !


!Cart methodsFor: 'item inspection' stamp: 'JA 6/7/2018 20:26:26'!
includes: anItem
	^items includes: anItem.! !

!Cart methodsFor: 'item inspection' stamp: 'MC 6/4/2018 21:45:49'!
isEmpty
	^items isEmpty.! !

!Cart methodsFor: 'item inspection' stamp: 'JA 6/7/2018 20:27:20'!
quantityFor: anItem
	^items occurrencesOf: anItem.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'MC 6/4/2018 21:23:27'!
forCatalog: aCatalog 
	^self new initializeFor: aCatalog.! !


!Cart class methodsFor: 'error handling' stamp: 'MC 6/4/2018 21:35:47'!
bookNotInCatalogMessage
	^'El libro no puede agregarse al carrito por no estar en el cat�logo'.! !

!Cart class methodsFor: 'error handling' stamp: 'JA 6/7/2018 20:31:28'!
itemQuantityShouldBeAnInteger
	^'Item quantity should be integer'.! !

!Cart class methodsFor: 'error handling' stamp: 'MC 6/6/2018 19:02:00'!
itemQuantityShouldBeOneOrMore
	^'Item quantity should be one or more'.! !


!classDefinition: #Market category: #TusLibros!
Object subclass: #Market
	instanceVariableNames: 'catalog users'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Market methodsFor: 'initialization' stamp: 'MC 6/6/2018 19:31:13'!
withUsers: knownUsers andCatalog: aCatalog
	users _ knownUsers.
	catalog _ aCatalog! !


!Market methodsFor: 'cart management' stamp: 'MC 6/6/2018 19:30:54'!
newCartFor: user
	(users includes: user) ifFalse: [
		self error: self class userNotKnown.
	].
	^Cart forCatalog: catalog.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Market class' category: #TusLibros!
Market class
	instanceVariableNames: ''!

!Market class methodsFor: 'instance creation' stamp: 'MC 6/6/2018 19:20:06'!
forUsers: users buyingFromCatalog: catalog
	^self new withUsers: users andCatalog: catalog.! !


!Market class methodsFor: 'error handling' stamp: 'MC 6/6/2018 19:30:03'!
userNotKnown
	^'No puede darse un carrito a un usuario desconocido'.! !
