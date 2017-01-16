local L = LibStub("AceLocale-3.0"):NewLocale("EasyFrames", "ruRU")
if not L then return end


L["loaded. Options:"] = "загружен. Настройки:"

L["Main options"] = "Главные настройки"
L["In main options you can set the global options like colored frames, class portraits, etc"] = "В окне главных настроек вы можете установить глобальные настройки фреймов, таких как Раскрасить фреймы здоровья в цвет класса, установить иконку класса в портрет и другие"

L["Percent"] = "Проценты"
L["Current + Max"] = "Текущее + Макс"
L["Current + Max + Percent"] = "Текущее + Макс + Проценты"

L["Frames"] = "Фреймы"
L["Setting for unit frames"] = "Настройки фреймов"

L["Class colored healthbars"] = "Раскрасить фреймы здоровья в цвет класса"
L["Healthbar color based on current health. IN DEVELOPMENT..."] = "В РАЗРАБОТКЕ... Цвет фреймов основан на текущем значении здоровья"
L["Frames healthbar color based on his current health"] = "Цвет фреймов основан на текущем значении здоровья"
L["If checked frames becomes class colored"] = "Если установлено фреймы раскрашиваются в цвет класса"
L["Custom buffsize"] = "Собственный размер бафов"
L["Buffs settings (like custom buffsize, highlight dispelled buffs, etc)"] = "Настройки бафов (использовать собственный размер бафов, подсвечивать бафы, которые могут быть рассеяны и другие)"
L["Turn on custom buffsize"] = "Собственный размер бафов"
L["Turn on custom target and focus frames buffsize"] = "Включить собственный размер бафов у цели и фокус фреймов"
L["Buffs"] = "Бафы"
L["Buffsize"] = "Размер бафов"
L["Self buffsize"] = "Размер своих бафов"
L["Buffsize that you create"] = "Размер бафов, которые вы создаете"
L["Highlight dispelled buffs"] = "Подсвечивать бафы, которые могут быть рассеяны"
L["Highlight buffs that can be dispelled from target frame"] = "Подсвечивать бафы у цели, которые могут быть рассеяны"
L["Dispelled buff scale"] = "Размер (scale) бафов (dispelled)"
L["Dispelled buff scale that can be dispelled from target frame"] = "Размер (scale) бафов, которые могут быть рассеяны"

L["Class portraits"] = "Иконка класса в портрете"
L["Replaces the unit-frame portrait with their class icon"] = "Заменяет портрет фрейма иконкой класса"

L["Texture"] = "Текстура"
L["Set the frames bar Texture"] = "Установить текстуру фреймов"

L["Bright frames border"] = "Светлые границы фреймов"
L["You can set frames border bright/dark color. From bright to dark. 0 - dark, 100 - bright"] = "Вы можете установить свет границ фреймов. От светлого к темному. 0 - темные границы, 100 - светлые"

L["Frames colors"] = "Цвета фреймов"
L["In this section you can set the default colors for friendly, enemy and neutral frames"] = "В этом разделе вы можете установить цвета фреймов по умолчанию для дружественных, враждебных или нейтральных целей"
L["Set default friendly healthbar color"] = "Цвет по умолчанию дружественных целей"
L["You can set the default friendly healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию дружественных к вам целей"
L["Set default enemy healthbar color"] = "Цвет по умолчанию враждебных целей"
L["You can set the default enemy healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию враждебных к вам целей"
L["Set default neutral healthbar color"] = "Цвет по умолчанию нейтральных целей"
L["You can set the default neutral healthbar color for frames"] = "Вы можете установить цвет фреймов по умолчанию нейтральных к вам целей"
L["Reset color to default"] = "Сбросить цвет"

L["Other"] = "Другое"
L["In this section you can set the settings like 'show welcome message' etc"] = "В этом разделе вы можете установить разные настройки не вошедшие в другие разделы (показывать приветственный текст в чате и другие)"
L["Show welcome message"] = "Показывать приветственный текст в чате"
L["Show welcome message when addon is loaded"] = "Показывать приветственный текст в чате когда аддон был загружен"


L["Player"] = "Игрок"
L["In player options you can set scale player frame, healthbar text format, etc"] = "В разделе Игрок вы можете установить размер (scale) фрейма игрока, установить формат HP и другие"
L["Show player name"] = "Показывать имя игрока"
L["Player frame scale"] = "Размер фрейма игрока"
L["Scale of player unit frame"] = "Размер (scale) фрейма игрока"
L["Enable hit indicators"] = "Показывать входящий урон и исцеление"
L["Show or hide the damage/heal which you take on your unit frame"] = "Показывать получаемый урон/исцеление на фрейме игрока"
L["Player healthbar text format"] = "Формат HP игрока"
L["Set the player healthbar text format"] = "Установить формат отображения здоровья игрока"
L["Show player specialbar"] = "Показывать фрейм классового ресурса"
L["Show or hide the player specialbar, like Paladin's holy power, Priest's orbs, Monk's harmony or Warlock's soul shards"] = "Показывать фрейм классового ресурса, такие как Энергия Света паладинов, Безумие пристов, Ци монахов, Осколки души чернокнижников и другие"
L["Show player resting icon"] = "Показывать иконку отдыха игрока"
L["Show or hide the player resting icon when player is resting (e.g. in the tavern or in the capital)"] = "Показывать иконку отдыха игрока когда он отдыхает (например, в таверне или в столице)"


L["Target"] = "Цель"
L["In target options you can set scale target frame, healthbar text format, etc"] = "В разделе Цель вы можете установить размер (scale) фрейма цели, установить формат HP и другие"
L["Target frame scale"] = "Размер фрейма цели"
L["Scale of target unit frame"] = "Размер (scale) фрейма цели"
L["Target healthbar text format"] = "Формат HP цели"
L["Set the target healthbar text format"] = "Установить формат отображения здоровья цели"
L["Show target of target frame"] = "Показывать цель цели"


L["Focus"] = "Фокус"
L["In focus options you can set scale focus frame, healthbar text format, etc"] = "В разделе Фокус вы можете установить размер (scale) фокус фрейма, установить формат HP и другие"
L["Focus frame scale"] = "Размер фокус фрейма"
L["Scale of focus unit frame"] = "Размер (scale) фокус фрейма"
L["Focus healthbar text format"] = "Формат HP фокус фрейма"
L["Set the focus healthbar text format"] = "Установить формат отображения здоровья фокус фрейма"
L["Show target of focus frame"] = "Показывать цель фокус фрейма"


L["Pet"] = "Питомец"
L["In pet options you can show/hide pet name, enable/disable pet hit indicators"] = "В разделе Питомец вы можете установить такие настройки как Показывать имя питомца, включить отображение входящего урона и исцеления питомца"
L["Show pet name"] = "Показывать имя питомца"
L["Show or hide the damage/heal which your pet take on pet unit frame"] = "Показывать получаемый урон/исцеление на фрейме питомца"

