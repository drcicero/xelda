return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 25,
  height = 22,
  tilewidth = 20,
  tileheight = 20,
  properties = {},
  tilesets = {
    {
      name = "All2",
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
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "background",
      x = 0,
      y = 0,
      width = 25,
      height = 22,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102,
        94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94, 93, 94,
        102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102, 101, 102
      }
    },
    {
      type = "tilelayer",
      name = "mid",
      x = 0,
      y = 0,
      width = 25,
      height = 22,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 89, 90, 0, 0, 0,
        0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 98, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 89, 90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 97, 98, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "objs",
      visible = true,
      opacity = 1,
      properties = {
        ["switch"] = "!lr"
      },
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 240,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 91,
          visible = true,
          properties = {
            ["change"] = "$change_water"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 300,
          y = 220,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!right"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 60,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 60,
          y = 380,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 400,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 120,
          y = 400,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 40,
          y = 140,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 380,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 380,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 220,
          y = 380,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 360,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 260,
          y = 360,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 340,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 260,
          y = 200,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 72,
          visible = true,
          properties = {
            ["CYAN"] = "right",
            ["YELLOW"] = "right_"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 180,
          y = 240,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 72,
          visible = true,
          properties = {
            ["CYAN"] = "left",
            ["YELLOW"] = "left_"
          }
        },
        {
          name = "cyan",
          type = "",
          shape = "rectangle",
          x = 349.333,
          y = 152,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 38,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 62.3333,
          y = 245.667,
          width = 35,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_puzzle_easy"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 406.333,
          y = 123,
          width = 30,
          height = 35,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_puzzle"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 140,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 120,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 380,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 300,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 31,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 17,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 400,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 400,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 300,
          y = 340,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 280,
          y = 340,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 87,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!left"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 99,
          visible = true,
          properties = {
            ["change"] = "eye"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 60,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 37,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 300,
          y = 260,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!right_"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 140,
          y = 220,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!left_"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 160,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 140,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 100,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 100,
          y = 120,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "!lr"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 88,
          visible = true,
          properties = {
            ["switch"] = "eye"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 220,
          y = 220,
          width = 20,
          height = 20,
          rotation = 0,
          gid = 120,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 230,
          y = 249.333,
          width = 20,
          height = 20,
          rotation = -180,
          gid = 104,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 62.5,
          y = 126,
          width = 35,
          height = 36,
          rotation = 0,
          visible = true,
          properties = {
            ["TO"] = "ice_time"
          }
        }
      }
    },
    {
      type = "tilelayer",
      name = "Water",
      x = 0,
      y = 0,
      width = 25,
      height = 22,
      visible = true,
      opacity = 0.43,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 109, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0,
        0, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 0
      }
    },
    {
      type = "tilelayer",
      name = "Ground",
      x = 0,
      y = 0,
      width = 25,
      height = 22,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 0, 0, 0, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137,
        137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 137,
        137, 112, 112, 112, 112, 112, 112, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137,
        137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137,
        137, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137,
        137, 137, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 112, 112, 137, 137,
        137, 137, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137,
        137, 137, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137,
        137, 137, 112, 112, 0, 0, 0, 0, 0, 0, 0, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137, 137, 137,
        137, 137, 112, 112, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 137, 137, 137, 137, 137, 137,
        137, 137, 112, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 112, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 112, 112, 0, 0, 0, 0, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 137, 112, 112, 112, 112, 112, 112, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137,
        137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137, 137
      }
    },
    {
      type = "objectgroup",
      name = "Zones",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 28,
          y = 7.66667,
          width = 440.334,
          height = 416,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 44.6667,
          y = 165,
          width = 404.666,
          height = 245.999,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
