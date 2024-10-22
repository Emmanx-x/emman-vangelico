-----------------For support, scripts, and more----------------
--------------- https://discord.gg/qBUx3y8v8u  -------------
---------------------------------------------------------------

local Translations = {
    general = {
        target_label = "Smash the glass"
    },
    error = {
            wrong_weapon = "You are using the wrong weapon!"
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
