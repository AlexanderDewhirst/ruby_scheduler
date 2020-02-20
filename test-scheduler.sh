#!/bin/bash

# In a RoR application, I would use an acceptance_specs file
# to load all test files. For this project, I've decided to
# simply use a bash script.
bundle exec rspec spec/lib/scheduler_spec.rb
bundle exec rspec spec/lib/scheduler/meeting_spec.rb
bundle exec rspec spec/lib/schedulder/schedule_spec.rb