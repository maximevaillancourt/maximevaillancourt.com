# This file fetches submitted guestbook entries from Netlify's API and updates a static data file.
# Use your secret values below (never commit them!) and run `ruby update_guestbook.rb`.

require 'httparty'

NETLIFY_PERSONAL_ACCESS_TOKEN = 'X-_-VHUrvHZDpTWlAbKKuo2IIDXp4-jAoDfy9_SbJBA'
NETLIFY_SITE_ID = '38ff355d-00b0-415c-b554-d15d45b60099'
NETLIFY_FORM_ID = '5fc9c239de84ab0008f74299'

headers = {
  'Authorization': "Bearer #{NETLIFY_PERSONAL_ACCESS_TOKEN}"
}

# Get form submissions from Netlify API
raw_messages_from_api = JSON.parse(HTTParty.get("https://api.netlify.com/api/v1/sites/#{NETLIFY_SITE_ID}/forms/#{NETLIFY_FORM_ID}/submissions", headers: headers).to_s)

# Parse raw messages and index by ID
messages_from_api = {}
raw_messages_from_api.each do |raw_message|
  messages_from_api[raw_message['id']] = {
    'netlify_submission_id' => raw_message['id'],
    'author' => CGI.escapeHTML(raw_message['name']),
    'timestamp' => DateTime.parse(raw_message['created_at']).strftime('%FT%T%:z'),
    'body' => CGI.escapeHTML(raw_message['body']),
  }
end

# Index existing messages by ID
existing_messages = YAML.load(File.read('_data/guestbook_messages.yml')) || []
existing_messages_by_id = existing_messages.each_with_object({}) do |message, existing_messages_by_id|
  existing_messages_by_id[message['netlify_submission_id']] = message
end

# Merge messages from API with existing messages using message IDs as unique key
all_messages = existing_messages_by_id
  .merge(messages_from_api)
  .values
  .sort_by { |m| m['timestamp'] }

# Update static data file
File.write('_data/guestbook_messages.yml', YAML.dump(all_messages))
