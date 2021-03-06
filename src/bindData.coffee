angular.module('classy.bindData', ['classy.core']).classy.plugin.controller
  # Based on @wuxiaoying's classy-initScope plugin
  localInject: ['$parse']

  options:
    enabled: true
    addToScope: true
    addToClass: true
    privatePrefix: '_'
    keyName: 'data'

  hasPrivatePrefix: (string) ->
    prefix = @options.privatePrefix
    if !prefix then false
    else string.slice(0, prefix.length) is prefix

  init: (klass, deps, module) ->
    # Adds objects returned by or set to the `$scope`
    if @options.enabled and klass.constructor::[@options.keyName]

      data = angular.copy klass.constructor::[@options.keyName]

      if angular.isFunction data then data = data.call klass
      else if angular.isObject data
        for key, value of data
          if angular.isString(value)
            getter = @$parse value
            data[key] = getter(klass)
          else
            data[key] = value


      for key, value of data
        if @options.addToClass
          klass[key] = value
        if @options.addToScope and !@hasPrivatePrefix(key) and deps.$scope
          deps.$scope[key] = value

    return
