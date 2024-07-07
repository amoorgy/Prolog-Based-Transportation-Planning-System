# Prolog-Based-Transportation-Planning-System

## Table of Contents
- [Introduction](#introduction)
- [Files Overview](#files-overview)
- [Predicates](#predicates)
- [Usage](#usage)
- [Known Issues](#known-issues)

---

## Introduction

This Prolog project manages scheduling and transportation for a group of students traveling to different campuses. The key functionality includes finding the earliest slots for classes, determining valid transportation routes, and constructing comprehensive travel plans considering various constraints.

---

## Files Overview

### slots_kb.pl
Contains the knowledge base for scheduled slots.

### transport_kb.pl
Contains the knowledge base for transportation routes, lines, and connections.

### Team_X.pl
Contains the implementation of various predicates to manage and query the scheduling and transportation data.

---

## Predicates

### Slots Predicates
- **group_days/2**: Finds all days where a group has scheduled slots.
  ```prolog
  group_days(Group, Day_Timings).
  ```

- **day_slots/4**: Lists all slots for a group on a specific day.
  ```prolog
  day_slots(Group, Week, Day, Slots).
  ```

- **earliest_slot/4**: Determines the earliest slot for a group on a given day.
  ```prolog
  earliest_slot(Group, Week, Day, Slot).
  ```

### Transportation Predicates
- **proper_connection/4**: Determines if there is a valid connection between two stations considering the line's directionality.
  ```prolog
  proper_connection(Station_A, Station_B, Duration, Line).
  ```

- **append_connection/6**: Appends a new connection to the list of routes.
  ```prolog
  append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes).
  ```

- **connected/8**: Finds a route from the source to the destination, adhering to the constraints of maximum duration and routes.
  ```prolog
  connected(Source, Destination, Week, Day, Max_Duration, Max_Routes, Duration, Routes).
  ```

### Time Conversion Predicates
- **mins_to_twentyfour_hr/3**: Converts minutes since midnight to a 24-hour format.
  ```prolog
  mins_to_twentyfour_hr(Minutes, Hours, Min).
  ```

- **twentyfour_hr_to_mins/3**: Converts a 24-hour format time to minutes since midnight.
  ```prolog
  twentyfour_hr_to_mins(Hours, Mins, Minutes).
  ```

- **slot_to_mins/2**: Converts a slot number to minutes since midnight based on its start time.
  ```prolog
  slot_to_mins(Slot_Num, Minutes).
  ```

### Main Predicate
- **travel_plan/5**: Constructs the travel plan for a group, considering home stations, group schedules, and constraints on maximum duration and routes.
  ```prolog
  travel_plan(Home_Stations, Group, Max_Duration, Max_Routes, Journeys).
  ```

---

## Usage

### Loading the Knowledge Base and Implementation
```prolog
:- [transport_kb, slots_kb, 'Team_X'].
```

### Querying for a Travel Plan
```prolog
?- travel_plan([home_station_1, home_station_2], group_1, 60, 3, Journeys).
```
This query will find possible journeys for `group_1` starting from either `home_station_1` or `home_station_2`, ensuring that the travel time does not exceed 60 minutes and the number of routes does not exceed 3. The resulting `Journeys` will list all valid travel plans.

---

## Known Issues

### connected/8 Predicate
The `connected/8` predicate, designed to find a route between two stations considering the constraints of maximum duration and routes, is still not completely functional. It requires further refinement to handle all edge cases and ensure accurate route finding.

### travel_plan/5 Predicate
The `travel_plan/5` predicate, which constructs comprehensive travel plans, also requires additional development. While it performs basic functionality, it may not cover all complex scenarios and constraints fully.

---

## Conclusion

This Prolog project lays the groundwork for managing student schedules and transportation planning. While some predicates are still under development, the provided functionality serves as a solid foundation for further enhancements. Contributions and suggestions for improvement are welcome.

---

### License
This project is licensed under the MIT License.

---

### Authors
- Team_X

---

### Acknowledgments
- Special thanks to the Prolog community for their support and resources.

---

For more information, refer to the individual files and their detailed comments.
