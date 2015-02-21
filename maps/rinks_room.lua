return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 6,
  tilewidth = 20,
  tileheight = 20,
  nextobjectid = 3,
  properties = {
    ["landmusic"] = "Village"
  },
  tilesets = {
    {
      name = "tileset",
      firstgid = 1,
      tilewidth = 20,
      tileheight = 20,
      spacing = 0,
      margin = 0,
      image = "../assets/tileset.png",
      imagewidth = 160,
      imageheight = 380,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 10,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107,
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107,
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107,
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107,
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107,
        107, 107, 107, 107, 107, 107, 107, 107, 107, 107
      }
    },
    {
      type = "tilelayer",
      name = "mid",
      x = 0,
      y = 0,
      width = 10,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 131, 0, 0, 0, 0, 124, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 131, 89, 90, 0,
        0, 0, 0, 0, 0, 123, 130, 97, 98, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "objs",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 144.333,
          y = 67,
          width = 30.6667,
          height = 34.6667,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "rinks_house"
          }
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 100,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 85,
          visible = true,
          properties = {
            ["text"] = "Dont forget to move, boy:\\n[left], [right], [up], [down]!\\n\\n ~ Mom"
          }
        }
      }
    },
    {
      type = "tilelayer",
      name = "Ground",
      x = 0,
      y = 0,
      width = 10,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        106, 106, 106, 106, 106, 106, 106, 106, 106, 106,
        106, 0, 0, 0, 0, 106, 106, 106, 106, 106,
        106, 0, 0, 0, 0, 0, 0, 0, 0, 106,
        106, 0, 0, 0, 0, 0, 0, 0, 0, 106,
        106, 113, 113, 0, 0, 0, 0, 0, 0, 106,
        106, 106, 106, 106, 106, 106, 106, 106, 106, 106
      }
    },
    {
      type = "tilelayer",
      name = "foreground",
      x = 0,
      y = 0,
      width = 10,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 132, 133, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
