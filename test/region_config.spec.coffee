helpers = require('./helpers')
EventEmitter = require('events').EventEmitter
AWS = helpers.AWS
MockService = helpers.MockService
Buffer = AWS.util.Buffer

describe 'region_config.js', ->
  it 'sets endpoint configuration option for default regions', ->
    service = new MockService
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('mockservice.mock-region.amazonaws.com')

  [AWS.CloudFront, AWS.IAM, AWS.ImportExport, AWS.Route53, AWS.STS].forEach (svcClass) ->
    it 'uses a global endpoint for ' + svcClass.serviceIdentifier, ->
      service = new svcClass
      expect(service.endpoint.host).to.equal(service.serviceIdentifier + '.amazonaws.com')
      expect(service.isGlobalEndpoint).to.equal(true)

  it 'always enables SSL for Route53', ->
    service = new AWS.Route53
    expect(service.config.sslEnabled).to.equal(true)

  it 'uses "global" endpoint for SimpleDB in us-east-1', ->
    service = new AWS.SimpleDB(region: 'us-east-1')
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('sdb.amazonaws.com')

  it 'uses "global" endpoint for SimpleDB in us-east-1', ->
    service = new AWS.S3(region: 'us-east-1')
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('s3.amazonaws.com')

  it 'does not use any global endpoints in cn-*', ->
    service = new AWS.IAM(region: 'cn-north-1')
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('iam.cn-north-1.amazonaws.com.cn')

  it 'enables signature version 4 signing in cn-*', ->
    service = new AWS.IAM(region: 'cn-north-1')
    expect(service.config.signatureVersion).to.equal('v4')

  it 'uses - as separator for S3 in public regions', ->
    service = new AWS.S3(region: 'us-west-2')
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('s3-us-west-2.amazonaws.com')

  it 'uses . as separator for S3 in cn-*', ->
    service = new AWS.S3(region: 'cn-north-1')
    expect(service.isGlobalEndpoint).to.equal(false)
    expect(service.endpoint.host).to.equal('s3.cn-north-1.amazonaws.com.cn')
