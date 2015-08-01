return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "2015-05-07",
  orientation = "orthogonal",
  width = 46,
  height = 15,
  tilewidth = 20,
  tileheight = 20,
  nextobjectid = 42,
  properties = {},
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
      imageheight = 440,
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
      type = "objectgroup",
      name = "moon",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {}
    },
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 46,
      height = 15,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 0, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 0, 0, 0, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 0, 0, 0, 0, 0, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 0, 0, 0, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 0, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60,
        67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68, 67, 68,
        59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60, 59, 60
      }
    },
    {
      type = "tilelayer",
      name = "mid",
      x = 0,
      y = 0,
      width = 46,
      height = 15,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0, 0,
        0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Ground",
      x = 0,
      y = 0,
      width = 46,
      height = 15,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74,
        74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74,
        74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74,
        74, 74, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 74, 74,
        74, 74, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 0, 0, 0, 0, 0, 0, 0, 0, 0, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 73, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 73, 73, 73, 0, 0, 0, 73, 73, 73, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74,
        74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 0, 0, 0, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74
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
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 260.667,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 5\\n\\nAlthough the GREEN ONE was able to weaken Nonag, it was not in his power to end the tragedy."
          }
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 761.167,
          y = 260.167,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "XELDAS SAGA\\n\\nOnce upon the time princess Xelda was born. Happily she lived her life until..."
          }
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 40,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 60,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 500,
          y = 60,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 124,
          visible = true,
          properties = {
            ["ghost"] = "true"
          }
        },
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 806.667,
          y = 164.667,
          width = 27,
          height = 37,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "palace"
          }
        },
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 220,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 72,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "sword",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 200,
          width = 20,
          height = 20,
          rotation = -270.274,
          gid = 50,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "king",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 220,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 139,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "mid",
          type = "",
          shape = "rectangle",
          x = 560,
          y = 123.5,
          width = 20.6667,
          height = 89.1667,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "drawing",
          type = "",
          shape = "rectangle",
          x = 439.917,
          y = 136.833,
          width = 19.1667,
          height = 87.5833,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "",
          type = "",
          shape = "rectangle",
          x = 710.667,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 2\\n\\nOne day she met the magician Nonag. To defeat death, he had turned himself into an foul creature. Now he was looking for a kingdom to rule in his evil ways."
          }
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 690.667,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 3\\n\\nNonag turned the sky pitch black, kidnapped Xelda and watched the confused people and the king until it was time for him to take over the kingdom."
          }
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 641.334,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 4\\n\\nSuddenly a boy wearing green from head to toe appeared and defeated him.\\nAnd they may or may not have lived happily ever after (depending on circumstances)."
          }
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 210.667,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 6\\n\\nPrincess Xelda gathered the wisest men around her, and together they banished Nonag to the moon."
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 190.667,
          y = 260.667,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 7\\n\\nEvery twenty Years the spell will have to be renewed by the ancestors of the Princess."
          }
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 84,
          visible = true,
          properties = {
            ["text"] = "PART 8\\n\\nHowever, when the spell breaks, a new Hero is born..."
          }
        },
        {
          id = 23,
          name = "offlimits",
          type = "",
          shape = "rectangle",
          x = 319,
          y = 123.417,
          width = 20.6667,
          height = 89.1667,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "lasttablet",
          type = "",
          shape = "rectangle",
          x = 98.167,
          y = 117.417,
          width = 20.6667,
          height = 89.1667,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 66.5,
          y = 162.833,
          width = 27,
          height = 37,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_entry"
          }
        },
        {
          id = 29,
          name = "moon",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 120,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 34,
          visible = true,
          properties = {
            ["ghost"] = ""
          }
        },
        {
          id = 30,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 240,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 31,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 240,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 32,
          name = "",
          type = "",
          shape = "rectangle",
          x = 460,
          y = 240,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 33,
          name = "",
          type = "",
          shape = "rectangle",
          x = 460,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 34,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 280,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 35,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 36,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 37,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 280,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 38,
          name = "",
          type = "",
          shape = "rectangle",
          x = 460,
          y = 280,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 39,
          name = "",
          type = "",
          shape = "rectangle",
          x = 460,
          y = 300,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 40,
          name = "",
          type = "",
          shape = "rectangle",
          x = 440,
          y = 300,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        },
        {
          id = 41,
          name = "",
          type = "",
          shape = "rectangle",
          x = 420,
          y = 300,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "bottom"
          }
        }
      }
    },
    {
      type = "tilelayer",
      name = "foreground",
      x = 0,
      y = 0,
      width = 46,
      height = 15,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 121, 121, 0, 121, 121, 0, 121, 121, 0, 0, 0, 83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 0, 0, 0, 121, 121, 0, 121, 121, 0, 121, 121, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 129, 129, 0, 129, 129, 0, 129, 129, 0, 121, 0, 83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 0, 121, 0, 129, 129, 0, 129, 129, 0, 129, 129, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 129, 0, 83, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83, 0, 129, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Zones",
      visible = false,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 520,
          y = 79,
          width = 381,
          height = 166,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = 338,
          y = 72.6667,
          width = 224.333,
          height = 176.667,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 28,
          name = "",
          type = "",
          shape = "rectangle",
          x = 18,
          y = 79,
          width = 362,
          height = 164,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
