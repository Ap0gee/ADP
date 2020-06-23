Scriptname AdpTimedReactivation extends ObjectReference  
{Reactivate the 'Slave' object reference after the specified time}

ObjectReference Property Slave  Auto  
{Reference object that this script will act upon}

Float Property ReActivationDelay = 1.1 Auto  
{Time, in seconds, that this script will wait before reactivating the 'Slave' object reference}

Float Property ReEnableDelay = 1.5 Auto
{Time, in seconds, that this script will wait before re-enabling the activator}

Bool SlaveActivated = False
Bool Initialized = False

import debug
import utility

Function verifyDelays()
	if (ReActivationDelay < 1.1)
		ReActivationDelay = 1.1
	endif
	if (ReEnableDelay < 1.1)
		ReEnableDelay = 1.1
	endif
endFunction

Function init()
	if ! Initialized
		verifyDelays()
		debug.trace("*ReActivationDelay" + ReActivationDelay)
		debug.trace("*ReEnableDelay" + ReEnableDelay)
		Initialized = False
	endif
endFunction

auto State waiting
	Event onBeginState()
		debug.trace("*waiting")
	endEvent

	Event onActivate(objectReference triggerRef)
		init()
		self.Slave.activate(self)
		goToState("countdown")
	endEvent
endState

State countdown
	Event onBeginState()
		debug.trace("*countdown")
		utility.wait(ReActivationDelay)
		Slave.activate(self)
		utility.wait(ReEnableDelay)
		goToState("waiting")
	endEvent

	Event onActivate(objectReference triggerRef)
	endEvent
endState
