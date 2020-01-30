local util = require('util')

local dozer = util.table.deepcopy(data.raw['car']['tank'])
do
  dozer.name = 'bulldozer'
  dozer.icon = '__dozer__/graphics/icons/bulldozer.png'
  dozer.icon_size = 32
  dozer.minable = {mining_time = 1, result = 'bulldozer'}
  dozer.max_health = 1500
  dozer.energy_per_hit_point = 0.5
  dozer.resistances = {
    {
      type = 'fire',
      decrease = 25,
      percent = 60
    },
    {
      type = 'physical',
      decrease = 25,
      percent = 40
    },
    {
      type = 'impact',
      decrease = 60,
      percent = 70
    },
    {
      type = 'explosion',
      decrease = 25,
      percent = 40
    },
    {
      type = 'acid',
      decrease = 20,
      percent = 30
    }
  }
  dozer.collision_box = {{-0.9, -1.3}, {0.9, 1.3}}
  dozer.selection_box = {{-0.9, -1.3}, {0.9, 1.3}}
  dozer.effectivity = 0.5
  dozer.braking_power = '300kW'
  dozer.burner = {
    fuel_category = 'chemical',
    effectivity = 0.65,
    fuel_inventory_size = 2,
    smoke = {
      {
        name = 'smoke',
        deviation = {0.25, 0.25},
        frequency = 50,
        position = {0, 1.5},
        slow_down_factor = 0.9,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
      }
    }
  }
  dozer.consumption = '750kW'
  dozer.animation = {
    layers = {
      {
        width = 158,
        height = 128,
        frame_count = 2,
        axially_symmetrical = false,
        direction_count = 64,
        shift = {-0.140625, -0.28125},
        animation_speed = 8,
        max_advance = 1,
        stripes = {
          {
            filename = '__dozer__/graphics/entity/bulldozer/base-1.png',
            width_in_frames = 2,
            height_in_frames = 16
          },
          {
            filename = '__dozer__/graphics/entity/bulldozer/base-2.png',
            width_in_frames = 2,
            height_in_frames = 16
          },
          {
            filename = '__dozer__/graphics/entity/bulldozer/base-3.png',
            width_in_frames = 2,
            height_in_frames = 16
          },
          {
            filename = '__dozer__/graphics/entity/bulldozer/base-4.png',
            width_in_frames = 2,
            height_in_frames = 16
          }
        }
      },
      {
        width = 95,
        height = 77,
        frame_count = 2,
        apply_runtime_tint = true,
        axially_symmetrical = false,
        direction_count = 64,
        shift = {-0.100625, -0.46625},
        max_advance = 1,
        line_length = 2,
        stripes = util.multiplystripes(
          2,
          {
            {
              filename = '__dozer__/graphics/entity/bulldozer/base-mask-1.png',
              width_in_frames = 1,
              height_in_frames = 22
            },
            {
              filename = '__dozer__/graphics/entity/bulldozer/base-mask-2.png',
              width_in_frames = 1,
              height_in_frames = 22
            },
            {
              filename = '__dozer__/graphics/entity/bulldozer/base-mask-3.png',
              width_in_frames = 1,
              height_in_frames = 20
            }
          }
        )
      },
      {
        priority = "low",
        width = 151,
        height = 98,
        frame_count = 2,
        draw_as_shadow = true,
        direction_count = 64,
        shift = util.by_pixel(17.5, 7),
        max_advance = 1,
        stripes = util.multiplystripes(2,
        {
          {
            filename = "__base__/graphics/entity/tank/tank-base-shadow-1.png",
            width_in_frames = 1,
            height_in_frames = 16,
          },
          {
            filename = "__base__/graphics/entity/tank/tank-base-shadow-2.png",
            width_in_frames = 1,
            height_in_frames = 16,
          },
          {
            filename = "__base__/graphics/entity/tank/tank-base-shadow-3.png",
            width_in_frames = 1,
            height_in_frames = 16,
          },
          {
            filename = "__base__/graphics/entity/tank/tank-base-shadow-4.png",
            width_in_frames = 1,
            height_in_frames = 16,
          }
        })
      }
    }
  }
  dozer.sound_minimum_speed = 0.15
  dozer.rotation_speed = 0.003
  dozer.tank_driving = true
  dozer.weight = 50000
end

local item = {
  type = 'item',
  name = 'bulldozer',
  icon = '__dozer__/graphics/icons/bulldozer.png',
  icon_size = 32,
  flags = {},
  subgroup = 'transport',
  order = 'b[personal-transport]-c[bulldozer]',
  place_result = 'bulldozer',
  stack_size = 1
}

local recipe = {
  type = 'recipe',
  name = 'bulldozer',
  enabled = false,
  energy_required = 15,
  ingredients = {
    {'tank', 1},
    {'electronic-circuit', 10},
    {'iron-gear-wheel', 20},
    {'steel-plate', 50},
  },
  result = 'bulldozer'
}

local tech = {
  type = 'technology',
  name = 'bulldozer',
  icon = '__dozer__/graphics/icons/bulldozer.png',
  icon_size = 32,
  effects = {
    {
      type = 'unlock-recipe',
      recipe = 'bulldozer'
    }
  },
  prerequisites = {'tanks'},
  unit = {
    count = 150,
    ingredients = {
      {'automation-science-pack', 1},
      {'logistic-science-pack', 1},
      {'chemical-science-pack', 1},
    },
    time = 20
  },
  order = 'e-c-c-z'
}

data:extend{dozer, item, recipe, tech}
