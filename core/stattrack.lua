local lovely = require("lovely")
local nativefs = require("nativefs")

Saturn.ST = {}

local localizations = {}
localizations.money_generators = {
  { id = "j_golden", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#2#{C:inactive}){}" },
  { id = "j_ticket", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#2#{C:inactive}){}" },
  { id = "j_business", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_delayed_grat", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#2#{C:inactive}){}" },
  { id = "j_faceless", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_todo_list", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_rough_gem", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#2#{C:inactive}){}" },
  { id = "j_matador", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#2#{C:inactive}){}" },
  { id = "j_cloud_9", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_rocket", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_satellite", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_mail", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#3#{C:inactive}){}" },
  { id = "j_gift", counter_text = "{C:inactive}(Total value added: {C:money}$#2#{C:inactive}){}" },
  { id = "j_reserved_parking", counter_text = "{C:inactive}(Total $$$ generated: {C:money}$#4#{C:inactive}){}" },
  { id = "j_trading", counter_text = "{C:inactive}(Total $$$ generated: {C:money}#2#{C:inactive}){}" },
  { id = "j_to_the_moon", counter_text = "{C:inactive}(Total $$$ generated: {C:money}#2#{C:inactive}){}" },
}
localizations.card_generators = {
  { id = "j_8_ball", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#3#{C:inactive}){}" },
  { id = "j_space", counter_text = "{C:inactive}(Total hands upgraded: {C:planet}#3#{C:inactive}){}" },
  { id = "j_dna", counter_text = "{C:inactive}(Total cards generated: {C:planet}#1#{C:inactive}){}" },
  { id = "j_sixth_sense", counter_text = "{C:inactive}(Total cards generated: {C:spectral}#1#{C:inactive}){}" },
  { id = "j_superposition", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#1#{C:inactive}){}" },
  { id = "j_seance", counter_text = "{C:inactive}(Total cards generated: {C:spectral}#2#{C:inactive}){}" },
  { id = "j_riff_raff", counter_text = "{C:inactive}(Total jokers generated: {C:joker}#2#{C:inactive}){}" },
  { id = "j_vagabond", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#2#{C:inactive}){}" },
  { id = "j_hallucination", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#3#{C:inactive}){}" },
  { id = "j_certificate", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#1#{C:inactive}){}" },
  { id = "j_cartomancer", counter_text = "{C:inactive}(Total cards generated: {C:tarot}#1#{C:inactive}){}" },
}
localizations.plus_mults = {
  { id = "j_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_greedy_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_lusty_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_wrathful_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_gluttenous_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_jolly", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_zany", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_mad", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_crazy", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_droll", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_half", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_ceremonial", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_mystic_summit", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_raised_fist", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#1#{C:inactive}){}" },
  { id = "j_fibonacci", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_abstract", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_gros_michel", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_even_steven", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_supernova", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#1#{C:inactive}){}" },
  { id = "j_ride_the_bus", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_green_joker", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_red_card", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_erosion", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_fortune_teller", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_flash", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_popcorn", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_trousers", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_smiley", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_swashbuckler", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_onyx_agate", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_shoot_the_moon", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_bootstraps", counter_text = "{C:inactive}(Total +mult activations: {C:mult}#4#{C:inactive}){}" },
}
localizations.plus_chips = {
  { id = "j_sly", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_wily", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_crafty", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_clever", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_devious", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_banner", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#2#{C:inactive}){}" },
  { id = "j_scary_face", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#2#{C:inactive}){}" },
  { id = "j_odd_todd", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#2#{C:inactive}){}" },
  { id = "j_runner", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_ice_cream", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_blue_joker", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_hiker", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#2#{C:inactive}){}" },
  { id = "j_square", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_stone", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_bull", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_castle", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#4#{C:inactive}){}" },
  { id = "j_arrowhead", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#2#{C:inactive}){}" },
  { id = "j_wee", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
  { id = "j_stuntman", counter_text = "{C:inactive}(Total +chips activations: {C:chips}#3#{C:inactive}){}" },
}
localizations.x_mults = {
  { id = "j_stencil", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_loyalty_card", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_steel_joker", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_blackboard", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_constellation", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_cavendish", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_card_sharp", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_madness", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_vampire", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_hologram", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_baron", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_obelisk", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_photograph", counter_text = "{C:inactive}(Total xmult increases: {C:mult}#2#{C:inactive}){}" },
  { id = "j_lucky_cat", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_baseball", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_ancient", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_ramen", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_campfire", counter_text = "{C:inactive}(Total sell activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_acrobat", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_throwback", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_bloodstone", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_glass", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_flower_pot", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_idol", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#4#{C:inactive}){}" },
  { id = "j_seeing_double", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_hit_the_road", counter_text = "{C:inactive}(Total xmult increases: {C:mult}#3#{C:inactive}){}" },
  { id = "j_duo", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_trio", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_family", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_order", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_tribe", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_drivers_license", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_caino", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#3#{C:inactive}){}" },
  { id = "j_triboulet", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#2#{C:inactive}){}" },
  { id = "j_yorick", counter_text = "{C:inactive}(Total xmult activations: {C:mult}#5#{C:inactive}){}" },
}
localizations.miscellaneous = {
  { id = "j_scholar", counter_text = "{C:inactive}(Total +mult/chips activations: {C:attention}#3#{C:inactive}){}" },
  {
    id = "j_walkie_talkie",
    counter_text = "{C:inactive}(Total +mult/chips activations: {C:attention}#3#{C:inactive}){}",
  },
  { id = "j_mime", counter_text = "{C:inactive}(Total retrigger activations: {C:attention}#1#{C:inactive}){}" },
  { id = "j_marble", counter_text = "{C:inactive}(Total stones added: {C:attention}#1#{C:inactive}){}" },
  { id = "j_midas_mask", counter_text = "{C:inactive}(Total cards modified: {C:attention}#1#{C:inactive}){}" },
  { id = "j_dusk", counter_text = "{C:inactive}(Total retrigger activations: {C:attention}#2#{C:inactive}){}" },
  { id = "j_hack", counter_text = "{C:inactive}(Total retrigger activations: {C:attention}#2#{C:inactive}){}" },
  { id = "j_burglar", counter_text = "{C:inactive}(Total hands given: {C:attention}#2#{C:inactive}){}" },
  {
    id = "j_sock_and_buskin",
    counter_text = "{C:inactive}(Total retrigger activations: {C:attention}#2#{C:inactive}){}",
  },
  { id = "j_hanging_chad", counter_text = "{C:inactive}(Total retrigger activations: {C:attention}#2#{C:inactive}){}" },
  { id = "j_burnt", counter_text = "{C:inactive}(Total planet levels: {C:attention}#1#{C:inactive}){}" },
  { id = "j_chicot", counter_text = "{C:inactive}(Total blinds deactivated: {C:attention}#1#{C:inactive}){}" },
  { id = "j_perkeo", counter_text = "{C:inactive}(Total perkolations: {C:attention}#1#{C:inactive}){}" },
}

function Saturn.ST.addCounterLocalization(type)
  for _, k in ipairs(localizations[type]) do
    local text = G.localization.descriptions.Joker[k.id].text
    table.insert(text, #text + 1, k.counter_text)
  end
end
