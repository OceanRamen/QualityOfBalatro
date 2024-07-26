local lovely = require("lovely")

VERSION = "1.0.0b"
VERSION = VERSION .. "-DEVELOPMENT"

function Saturn:set_globals()
  _RELEASE_MODE = false
  self.VERSION = VERSION
  self.MOD_PATH = lovely.mod_dir .. "/Saturn/"
  
  self.calculating_joker = false
  self.calculating_score = false
  self.calculating_card = false
  
  self.add_dollar_amt = 0
  self.dollar_update = false
  self.SETTINGS = {
    modules = {
      stattrack = {
        features = {
          joker_tracking = {
            groups = {
              mult_plus = false,
              money_generators = true,
              card_generators = true,
              miscellaneous = true,
              mult_mult = false,
              chips_plus = false,
            },
            enabled = true,
          },
        },
        enabled = true,
      },
      preferences = {
        remove_animations = {
          enabled = false,
        },
        compact_view = {
          enabled = false,
        },
      },
      highscore = {
        features = {
          highscore_counter = {
            groups = {
              activations = false,
              x_mult_scale = true,
              money_generators = true,
              card_generators = true,
              miscellaneous = true,
              plus_mult_scale = true,
              plus_chips_scale = true,
              retriggers = false,
            },
            counters = {},
          }
        },
        enabled = true,
      },
      deckviewer_plus = {
        features = {
          hide_played_cards = true,
        },
        enabled = true,
      },
      challenger_plus = {
        features = {
          mass_use_button = true,
          retry_button = true,
        },
        enabled = true,
      },
    },
  }

  -- stuff for ui
  self.card_display = {}
  self.current_page = 0
  self.current_page_text = {}

  self.HIGHSCORES = {}

  self.UI = {
    colour_scheme = {},
  }
end

S = Saturn()
