# Change Log

## 0.0.15 Elos - 2020-07-22

* Add option to copy the playback link in a recording.
* Add a table `consumer_configs` to store configurations for each customer. Indexed by the key
  the consumer uses to launch the LTI.
* Add a disclaimer in the external access page. Configure for each customer, by default won't
  show anything.
* Set the duration on create. By default won't set the duration, only when the consumer is configured
  to do so. Sets the duration to the duration of the scheduled meeting plus one hour.
* Serve an html in `/healthz.html` to try to speed up the application boot. Kubernetes will check
  it right after the pod starts and it will take a while to respond while Rails loads, so this
  loading time won't affect user requests.
* Add `Room#consumer_key` to optimize db queries. Uses it directly instead of having to list
  all app launches to get the latest one.
* Set `key` as unique in the `bigbluebutton_servers` and `consumer_configs` tables.
* Show meetings for one hour more than their duration to make it a little better for people in
  other timezones until we have a proper solution for multiple timezones.


## 0.0.14 Elos - 2020-07-20

* Fix to use the locale in the launch over the default locale of the browser.
* Fix validation of the room when accessing open routes for scheduled meetings. Accessing
  `:room/scheduled_meetings/:id/external`, for example, was not validating the room, so any meeting
  could be accessed in the scope of any valid room. Now scheduled meetings are only searched
  in the scope of the current room.


## 0.0.13 Elos - 2020-07-19

* Fix the datetime input in mobile by disabling the native integration. Will show
  the selector just as it does in a desktop browser.
* Configure the session cookie with SameSite=None and Secure. Necessary to open the application
  in an iframe, Chrome started blocking cookies otherwise.
* When creating a meeting, initiate it with attributes from its room, that can be configured
  using custom parameters in the launch.
* Add custom parameters to the launch to enable/disable edition of the flags `all_moderators`
  and `wait_moderator`. The parameters are called `allow_all_moderators` and `allow_wait_moderator`.
  If they are not informed, users are allowed to edit the attributes when editing and creating
  scheduled meetings. If they are informed with `true` (has to be this value), users are also
  allowed to edit the attributes. If they are informed with any other value, users will not
  see the attributes in the views, will not be allowed to edit them and they will assume
  their default values when used (`wait_moderator=true` and `all_moderators=false`).
  * New migration to include the attributes `allow_all_moderators` and `allow_wait_moderator`
    on the table `rooms`.


## 0.0.12 Elos - 2020-07-13