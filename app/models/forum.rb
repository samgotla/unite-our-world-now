class Forum < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  belongs_to :parent, class: Forum, primary_key: 'id', foreign_key: 'parent_id'

  def self.generate(user)
    results = Geocoder.search(user.zip_code)

    if results.blank?
      return false
    end

    county_name = nil
    county_forum_name = nil
    
    best = results[0]
    addr_comps = best.data['address_components']

    if addr_comps.has_key?('county')
      county_name = addr_comps['county']
      county_forum_name = '%s, %s' % [ county_name, best.state_code ]
    end

    city_forum_name = '%s, %s' % [ best.city, best.state_code ]

    Forum.transaction do

      # Find or create forums by name
      world_forum = Forum.find_or_create_by(name: 'World')
      country_forum = Forum.find_or_create_by(name: best.country)
      state_forum = Forum.find_or_create_by(name: best.state_code)

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

      return user.update(forum: city_forum)
    end
  end
end
