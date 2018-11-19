################################################################################
# The purpose of this driver file is to generate a discussion that contains
# all types of system messages to ensure each type is working properly.  Since
# there is no public facing API for system messages, the necessary public API
# methods that cause system messages to occur must be called.
#
# This driver file assumes the Kinetic SDK is located in the relative directory:
#   - vendor/kinetic-sdk-rb
# or that this file is run from a subdirectory within the SDK samples directory:
#   - kinetic-sdk-rb/samples/discussion-system-messages
#
# The configuration file must conform to the sample-config.yaml found in the
# config subdirectory:
#   - kinetic-sdk-rb/samples/discussion-system-messages/config/sample-config.yaml
#
# 
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
# 3. ruby discussions-system-messages.rb <config-file-name.yaml>
#
################################################################################

# Determine the Present Working Directory
pwd = File.expand_path(File.dirname(__FILE__))

if Dir.exist?('vendor')
  # Require the Kinetic SDK from the vendor directory
  require File.join(pwd, 'vendor', 'kinetic-sdk-rb', 'kinetic-sdk')
elsif File.exist?(File.join(pwd, '..', '..', 'kinetic-sdk.rb'))
  # Assume this script is running from the samples directory
  require File.join(pwd, '..', '..', 'kinetic-sdk')
else
  puts "Cannot find the kinetic-sdk"
  exit
end

# Configuration file is the first command line argument
if ARGV.size == 0
  puts "A configuration file must be specified as the first parameter"
  exit
end

# Load the configuration file
config_file_name = ARGV[0]
config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', config_file_name)
config = YAML::load_file(config_file)

# Kinetic Discussion SDK
sdk = KineticSdk::Discussions.new(config)

# Cleanup and exit if specified
if ARGV.size > 1 && ARGV[1] == "cleanup"
  JSON.parse(sdk.find_discussions.content_string)['discussions'].each do |d|
    if (d['title'].start_with?('SDK Testing'))
      puts("Deleting discussion \"#{d['title']}\" - #{d['id']}")
      sdk.delete_discussion(d['id'])
    else
      puts("Keeping discussion \"#{d['title']}\" - #{d['id']}")
    end
  end
  exit
end

# Create a discussion
discussion_response = sdk.add_discussion({"title" => "SDK Testing - #{Time.now.to_i}"})
discussion_id = JSON.parse(discussion_response.content_string)['discussion']['id']

# Update the discussion - (DiscussionUpdateMessage)
sdk.update_discussion(discussion_id, {"description" => "Discussion for testing system messages"})

# Invite an email - (InvitationSentMessage)
sdk.add_invitation_by_email(discussion_id, config[:invitation_email], "Join the discussion")

# Resend the email invitation - (InvitationResentMessage)
sdk.resend_invitation_by_email(discussion_id, config[:invitation_email], "Please join the discussion")

# Delete the email invitation - (InvitationRemovedMessage)
sdk.delete_invitation_by_email(discussion_id, config[:invitation_email])

# Create a participant - (ParticipantCreatedMessage)
sdk.add_participant(discussion_id, config[:admin_username])

# Delete a participant - (ParticipantRemovedMessage)
sdk.delete_participant(discussion_id, config[:admin_username])

# Delete current participant - (ParticipantLeftMessage)
sdk.delete_participant(discussion_id, config[:username])

# Create a message
message_response = sdk.add_message(discussion_id, "Hello World!")
message_id = JSON.parse(message_response.content_string)['message']['id']

# Update the message - (MessageUpdatedMessage)
sdk.update_message(discussion_id, message_id, "Goodbye cruel world!")

# Subscribe the current user to the topic
sdk.subscribe(discussion_id)