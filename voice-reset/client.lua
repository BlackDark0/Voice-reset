local Config = Config or {}
local Framework = Config.Framework or 'qbcore'

local QBCore, ESX

Citizen.CreateThread(function()
    while QBCore == nil and ESX == nil do
        Citizen.Wait(0)
        if Framework == 'qbcore' and exports['qb-core'] then
            QBCore = exports['qb-core']:GetCoreObject()
        elseif Framework == 'esx' and exports['esx:getSharedObject'] then
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

local function showNotificationQBCore(message, type)
    if QBCore and QBCore.Functions then
        QBCore.Functions.Notify(message, type)
    end
end

local function showNotificationESX(message)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(message)
    end
end

local function showNotification(message)
    if Framework == 'qbcore' then
        showNotificationQBCore(message, 'success')
    elseif Framework == 'esx' then
        showNotificationESX(message)
    end
end

RegisterCommand('rvoz', function()     -- Comando para restaurar el chat de voz 'rvoz' lo puedes cambiar si quieres
    NetworkClearVoiceChannel()
    NetworkSessionVoiceLeave()
    Wait(50)
    NetworkSetVoiceActive(false)
    MumbleClearVoiceTarget(2)
    Wait(1000)
    MumbleSetVoiceTarget(2)
    NetworkSetVoiceActive(true)
    showNotification('El chat de voz ha sido restaurado.')

    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"^1Sistema^0", "El chat de voz ha sido restaurado."}
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/rvoz', 'Restaurar el chat de voz')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[BlackDark0] ^0El script " .. resourceName .. " se ha iniciado correctamente.")
    end
end)

Citizen.CreateThread(function()
    if GetResourceState(GetCurrentResourceName()) == 'started' then
        print("^1[BlackDark0] ^0El script " .. GetCurrentResourceName() .. " ha sido cargado exitosamente.")
    end
end)
