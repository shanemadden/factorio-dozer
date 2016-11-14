data:extend(
{
  {
    type = "car",
    name = "bulldozer",
    icon = "__bulldozer__/graphics/icons/bulldozer.png",
    flags = {"pushable", "placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "bulldozer"},
    max_health = 1500,
    corpse = "medium-remnants",
    dying_explosion = "medium-explosion",
    energy_per_hit_point = 0.5,
    resistances =
    {
      {
        type = "fire",
        decrease = 25,
        percent = 60
      },
      {
        type = "physical",
        decrease = 25,
        percent = 40
      },
      {
        type = "impact",
        decrease = 60,
        percent = 70
      },
      {
        type = "explosion",
        decrease = 25,
        percent = 40
      },
      {
        type = "acid",
        decrease = 20,
        percent = 30
      }
    },
    collision_box = {{-0.9, -1.3}, {0.9, 1.3}},
    selection_box = {{-0.9, -1.3}, {0.9, 1.3}},
    effectivity = 0.5,
    braking_power = "300kW",
    burner =
    {
      effectivity = 0.65,
      fuel_inventory_size = 2,
      smoke =
      {
        {
          name = "smoke",
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
    },
    consumption = "750kW",
    friction = 2e-3,
    light =
    {
      {
        type = "oriented",
        minimum_darkness = 0.3,
        picture =
        {
          filename = "__core__/graphics/light-cone.png",
          priority = "medium",
          scale = 2,
          width = 200,
          height = 200
        },
        shift = {-0.6, -14},
        size = 2,
        intensity = 0.6
      },
      {
        type = "oriented",
        minimum_darkness = 0.3,
        picture =
        {
          filename = "__core__/graphics/light-cone.png",
          priority = "medium",
          scale = 2,
          width = 200,
          height = 200
        },
        shift = {0.6, -14},
        size = 2,
        intensity = 0.6
      }
    },
    animation =
    {
      layers =
      {
        {
          width = 158,
          height = 128,
          frame_count = 2,
          axially_symmetrical = false,
          direction_count = 64,
          shift = {-0.140625, -0.28125},
          animation_speed = 8,
          max_advance = 1,
          stripes =
          {
            {
             filename = "__bulldozer__/graphics/entity/bulldozer/base-1.png",
             width_in_frames = 2,
             height_in_frames = 16,
            },
            {
             filename = "__bulldozer__/graphics/entity/bulldozer/base-2.png",
             width_in_frames = 2,
             height_in_frames = 16,
            },
            {
             filename = "__bulldozer__/graphics/entity/bulldozer/base-3.png",
             width_in_frames = 2,
             height_in_frames = 16,
            },
            {
             filename = "__bulldozer__/graphics/entity/bulldozer/base-4.png",
             width_in_frames = 2,
             height_in_frames = 16,
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
          stripes = util.multiplystripes(2,
          {
            {
              filename = "__bulldozer__/graphics/entity/bulldozer/base-mask-1.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__bulldozer__/graphics/entity/bulldozer/base-mask-2.png",
              width_in_frames = 1,
              height_in_frames = 22,
            },
            {
              filename = "__bulldozer__/graphics/entity/bulldozer/base-mask-3.png",
              width_in_frames = 1,
              height_in_frames = 20,
            },
          })
        },
        {
          width = 154,
          height = 99,
          frame_count = 2,
          draw_as_shadow = true,
          axially_symmetrical = false,
          direction_count = 64,
          shift = {0.59375, 0.328125},
          max_advance = 1,
          stripes = util.multiplystripes(2,
          {
           {
            filename = "__base__/graphics/entity/tank/base-shadow-1.png",
            width_in_frames = 1,
            height_in_frames = 16,
           },
           {
            filename = "__base__/graphics/entity/tank/base-shadow-2.png",
            width_in_frames = 1,
            height_in_frames = 16,
           },
           {
            filename = "__base__/graphics/entity/tank/base-shadow-3.png",
            width_in_frames = 1,
            height_in_frames = 16,
           },
           {
            filename = "__base__/graphics/entity/tank/base-shadow-4.png",
            width_in_frames = 1,
            height_in_frames = 16,
           }
          })
        }
      }
    },
    stop_trigger_speed = 0.2,
    stop_trigger =
    {
      {
        type = "play-sound",
        sound =
        {
          {
            filename = "__base__/sound/car-breaks.ogg",
            volume = 0.6
          },
        }
      },
    },
    crash_trigger = crash_trigger(),
    sound_minimum_speed = 0.15;
    working_sound =
    {
      sound =
      {
        filename = "__base__/sound/car-engine.ogg",
        volume = 0.6
      },
      activate_sound =
      {
        filename = "__base__/sound/car-engine-start.ogg",
        volume = 0.6
      },
      deactivate_sound =
      {
        filename = "__base__/sound/car-engine-stop.ogg",
        volume = 0.6
      },
      match_speed_to_activity = true,
    },
    open_sound = { filename = "__base__/sound/car-door-open.ogg", volume=0.7 },
    close_sound = { filename = "__base__/sound/car-door-close.ogg", volume = 0.7 },
    rotation_speed = 0.0035,
    tank_driving = true,
    weight = 5000,
    inventory_size = 80,
  },
}
)