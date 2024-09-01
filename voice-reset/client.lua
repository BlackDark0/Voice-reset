-- client.lua

-- Cargar configuración
local Config = Config or {}
local Framework = Config.Framework or 'qbcore'

-- Cargar el objeto de framework apropiado
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

-- Función para mostrar notificaciones usando QBCore
local function showNotificationQBCore(message, type)
    if QBCore and QBCore.Functions then
        QBCore.Functions.Notify(message, type)
    end
end

-- Función para mostrar notificaciones usando ESX
local function showNotificationESX(message)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(message)
    end
end

-- Mostrar notificación
local function showNotification(message)
    if Framework == 'qbcore' then
        showNotificationQBCore(message, 'success')
    elseif Framework == 'esx' then
        showNotificationESX(message)
    end
end

-- Registrar el comando 'rvoz'
RegisterCommand('rvoz', function()
    -- Comando para restaurar el chat de voz
    NetworkClearVoiceChannel()
    NetworkSessionVoiceLeave()
    Wait(50)
    NetworkSetVoiceActive(false)
    MumbleClearVoiceTarget(2)
    Wait(1000)
    MumbleSetVoiceTarget(2)
    NetworkSetVoiceActive(true)

    -- Notificación usando QBCore o ESX
    showNotification('El chat de voz ha sido restaurado.')

    -- Notificación en el chat con "Sistema" en rojo
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"^1Sistema^0", "El chat de voz ha sido restaurado."}
    })
end)

-- Agregar sugerencia de comando al chat
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/rvoz', 'Restaurar el chat de voz')
end)

-- Mensaje en la consola del servidor (txAdmin) al iniciar o reiniciar el recurso
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[BlackDark0] ^0El script " .. resourceName .. " se ha iniciado correctamente.")
    end
end)

-- Mostrar mensaje de inicio cuando el recurso se carga/reinicia
Citizen.CreateThread(function()
    if GetResourceState(GetCurrentResourceName()) == 'started' then
        print("^1[BlackDark0] ^0El script " .. GetCurrentResourceName() .. " ha sido cargado exitosamente.")
    end
end)
