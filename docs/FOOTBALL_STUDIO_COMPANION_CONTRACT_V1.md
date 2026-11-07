# Football Studio Companion Contract V1

## Ownership and scope

Football Studio is an optional, separately installed Android application with
package name `com.quantumlab.dinopolo`. Unified Math Tutor owns only its small
companion descriptor and the learner-facing entry point. The companion owns
its lessons, activities, achievements, and all progress it stores.

V1 does not copy or embed Football Studio source, Dino Football, Dino Polo,
Glint, Moon Renderer Check, 3D assets, or game simulation. Moon Renderer Check
is not presented in Unified Math Tutor.

## No-data-sharing policy

Unified Math Tutor does not inspect, read, write, reset, or synchronize
Football Studio data. The Android boundary only checks whether the package has
a launcher activity and, on request, starts that activity using Android's
normal launch intent. It does not request storage permissions or communicate
with Football Studio through a data API.

Achievements and learning progress remain on the device in Football Studio for
V1. The companion is described as offering applied-learning activities in
coordinates, ratio and scale, angles, distance-time-speed, area, and algebra;
its completion data is not evidence recorded by Unified Math Tutor.

## Android-only availability and failure behaviour

The feature is available only on Android. Android package visibility is
limited to `com.quantumlab.dinopolo`. If the package or launcher activity is
not found, the screen says Football Studio is unavailable and that it must be
installed separately; it does not show an action that falsely implies it can
open a lesson.

If availability cannot be checked, or Android cannot launch an installed
companion, the screen reports that condition and offers a truthful retry.
Non-Android platforms identify that the companion is Android-only.

## Future opt-in sharing options

Any future progress sharing requires a separately reviewed design and an
explicit learner/guardian opt-in. Options could include a user-initiated local
export/import format or a narrowly scoped, versioned inter-app contract.
Neither option is implemented or implied by V1; any such work must define
consent, data minimization, revocation, and deletion behaviour before release.
