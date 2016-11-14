data:extend(
{
  {
    type = "technology",
    name = "bulldozer",
    icon = "__bulldozer__/graphics/icons/bulldozer.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "bulldozer"
      },
    },
    prerequisites = {"automobilism"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 2},
        {"science-pack-2", 1}
      },
      time = 20
    },
    order = "e-c-c"
  },
}
)