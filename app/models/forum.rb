class Forum < ActiveRecord::Base
  MIN_TERM_LEN = 3

  validates :name, presence: true, uniqueness: true

  belongs_to :parent, class: Forum, primary_key: 'id', foreign_key: 'parent_id'
  has_many :children, class: Forum, primary_key: 'id', foreign_key: 'parent_id'

  def self.generate(user, loc_key)

    # Search based on last changed attributes
    if loc_key == :zip
      results = Geocoder.search(user.zip_code)
    else
      results = Geocoder.search([ user.latitude, user.longitude ])
    end

    if results.blank?
      return false
    end

    county_name = nil
    county_forum_name = nil
    
    best = results[0]
    addr_comps = best.data['address_components']

    # Always use full state name
    state_name = Carmen::Country.named(best.country).subregions.coded(best.state_code).name

    if addr_comps.has_key?('county')
      county_name = addr_comps['county']
      county_forum_name = '%s, %s' % [ county_name, state_name ]
    end

    city_forum_name = '%s, %s' % [ best.city, state_name ]

    Forum.transaction do

      # Find or create forums by name
      world_forum = Forum.find_or_create_by(name: 'World')
      country_forum = Forum.find_or_create_by(name: best.country)
      state_forum = Forum.find_or_create_by(name: state_name)

      # Might not always get a county
      if county_forum_name
        county_forum = Forum.find_or_create_by(name: county_forum_name)
      end
      
      city_forum = Forum.find_or_create_by(name: city_forum_name)

      # Assign parent associations
      # World --> Country --> State --> County --> City
      # If no county: World --> Country --> State --> city
      country_forum.parent = world_forum
      state_forum.parent = country_forum

      if county_forum
        county_forum.parent = state_forum
        city_forum.parent = county_forum
      else
        city_forum.parent = state_forum
      end

      country_forum.save!
      state_forum.save!

      if county_forum
        county_forum.save!
      end
      
      city_forum.save!

      return user.update(
               forum: city_forum,
               latitude: best.latitude,
               longitude: best.longitude,
               zip_code: best.zip
             )
    end
  end
end
