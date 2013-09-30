request = require 'request-json'

# Class to facilitate application' permissions management
class exports.Manifest

    download: (app, callback) ->
        path = (app.git).substring(19, (app.git.length - 4))

        client = request.newClient "https://raw.github.com/"
        if app.branch?
            path = path + '/' + app.branch
        else
            path = path + '/master'

        client.get path + '/package.json', (err, res, body) =>
            callback err if err
            @config = body
            callback null

    getPermissions: (callback) =>
        if @config["cozy-permissions"]?
            callback @config["cozy-permissions"]
        else 
            callback {}

    getWidget: (callback) =>
        if @config['cozy-widget']?
            callback @config["cozy-widget"]
        else callback null

    getDescription: (callback) =>
        if @config['description']?
            callback @config["description"]
        else callback null

    getMetaData: (callback) =>
        metaData = {}

        if @config.description?
            metaData.description = @config.description

        if @config.name?
            metaData.name = @config.name.replace 'cozy-', ''

        if @config['cozy-displayName']?
            metaData.displayName = @config['cozy-displayName']
        else
            metaData.displayName = @config.name.replace 'cozy-', ''

        if @config['cozy-permissions']?
            metaData.permissions = @config['cozy-permissions']
        callback metaData