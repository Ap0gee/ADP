Scriptname AdpAndGateActivation extends ObjectReference  
{Conditionally activate the 'Slave' object reference based on the state of both referenced 'Activator' objects.}

import debug

ObjectReference Property Activator_1  Auto  
{Reference to an activator object}

ObjectReference Property Activator_2  Auto  
{Reference to an activator object}

ObjectReference Property Slave  Auto  
{Object that this Activator will activate upon meeting the defined conditions}

bool Initialized = False
bool SlaveActivated = False
float A_1 
float A_2
float TriggerActivationDelay = 2.0
objectReference globalTriggerRef

Function Init()
	if !Initialized
		A_1 = Activator_1.X + Activator_1.Y
		A_2 = Activator_2.X + Activator_2.Y
		Initialized = True
		debug.trace("*initialized" )
		debug.trace("*A_1=" + A_1)
		debug.trace("*A-2=" + A_2)
	endif
endFunction

Function goToStateConditional(objectReference triggerRef, String state_1, String state_2) 
		setGlobalTrigger(triggerRef)
		float triggerID = triggerRef.X + triggerRef.Y
		
		if triggerID == A_1
			goToState(state_1)
		elseif triggerID == A_2
			goToState(state_2)
		endif
endFunction

Function activateSlave(bool isActivated)
	Slave.activate(self)
	SlaveActivated = isActivated
endFunction

Function timedTriggerActivationToggle(float seconds)
	debug.trace("*input blocked")
	BlockActivation(True)
	form triggerForm = globalTriggerRef.GetBaseObject()
	string previousName = triggerForm.GetName()
	triggerForm.SetName("")
	utility.wait(seconds)
	triggerForm.SetName(previousName)
	BlockActivation(False)
	debug.trace("*input unblocked")
endFunction

Function setGlobalTrigger(objectReference triggerRef)
	globalTriggerRef = triggerRef
endFunction

auto State waiting
	Event onBeginState()
		timedTriggerActivationToggle(TriggerActivationDelay)
		debug.trace("*waiting")
	endEvent
	
 	Event onActivate (objectReference triggerRef)
		Init()
		goToStateConditional(triggerRef, "a1_on", "a2_on")	
	endEvent
endState

State a1_on
	Event onBeginState()
		debug.trace("*a1_on")
		if (SlaveActivated)
			activateSlave(False)
		endif
		timedTriggerActivationToggle(TriggerActivationDelay)
	endEvent

	Event  onActivate (objectReference triggerRef)
		goToStateConditional(triggerRef, "waiting", "activate")	
	endEvent
endState

State a2_on
	Event onBeginState()
		debug.trace("*a2_on")
		if (SlaveActivated)
			activateSlave(False)
		endif
		timedTriggerActivationToggle(TriggerActivationDelay)
	endEvent

	Event onActivate (objectReference triggerRef)
		goToStateConditional(triggerRef, "activate", "waiting")	
	endEvent
endState

State activate
	Event onBeginState()
		debug.trace("*activate")
		if (!SlaveActivated)
			activateSlave(True)	
		endif
		timedTriggerActivationToggle(TriggerActivationDelay)
	endEvent

	Event onActivate (objectReference triggerRef)
		goToStateConditional(triggerRef, "a2_on", "a1_on")	
	endEvent
endState
