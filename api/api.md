# Create Event

Creates a new sailing or rowing event.

### Inputs

* Member Id - unique id of the member creating the event
* Title - only a few words
* Description - describes the event (a few sentences)
* Start Date - event start date
* End Date -  event end date (only if different from start date)
* Meet Time - expected meet time on the start date
* Launch Time - expected launch time
* Off Water Time - expected off water time (on end date)
* Tide Peek Time - expected tide changeover (optional)

### Outputs

* Event Id - unique event identifier

### Conditions
The member creating the event must have a permission to create events.

# Update Event

Allows changing the event attributes (see create event).

### Inputs
* Member Id - unique id of the member updating the event
* Event Attributes  - that are changing

### Conditions
The member creating the event must have a permission to create events.
Or the member is an admin.

# Delete Event

Deletes an event.

### Inputs
* Member Id - unique id of the member deleting the event
* Event Id - from created event

### Conditions
The member creating the event must have a permission to create events and must be the event creator.
Or the member is an admin.

# Cancel Event

Cancels an existing event.

### Inputs
* Member Id - unique id of the member cancelling the event
* Event Id - from created event

### Conditions
The member creating the event must have a permission to create events.
Or the member is an admin.

# Reactivate Event

Restores a cancelled event.

### Inputs
* Member Id - unique id of the member re-activating the event
* Event Id - from created event

### Conditions
The member creating the event must have a permission to create events.
Or the member is an admin.

# Join Event

Allows a member or associated members to join an event.

## Inputs
* Event Id - from created event
* Member Id - unique member Id that performs the action
* List of Member Names

### Conditions
The member can only join himself and associated members.
Admin does not have permission to add members.

# Leave Event

Allows a member or associated members to leave an event that they have joined.

## Inputs
* Event Id - from created event
* Member Id - unique member Id that performs the action
* List of Member Names

### Conditions
The member can only remove himself and associated members.
Admin can also remove members from the event.

# Appoint Event Leader

Allows event organiser or admin to appoint an event leader.

## Inputs
* Event Id - from created event
* Member Id
* List of Member Ids and Member Names

# Swap Event Leader

Allows the admin, event organiser or event leader to appoint a different event leader.

## Inputs
* Event Id - from created event
* Member Id
* Original Member Id and Member Name
* New Member Id and Member Name