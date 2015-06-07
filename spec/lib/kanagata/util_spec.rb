require 'spec_helper'
require 'tmpdir'

module PatchedString
  refine String do
    def ~
      mergin = scan(/^ +/).map(&:size).min
      gsub(/^ {#{mergin}}/, '')
    end
  end
end
using PatchedString

describe Kanagata::Util do
  let(:util) {
    object = Object.new
    object.extend(Kanagata::Util)
  }

  context '#load_and_validate' do
    it 'load yaml' do
      Dir.mktmpdir do |dir|
        yaml = ~<<-"EOF"
          target:
            attributes:
              key1: value1
              key2: value2
              array:
                - 1
                - 2
            templates_dir: ./kanagata
            templates:
              - path: ./hoge.json
              - path: ./fuga.rb
                name: <%= key1 %>.rb
        EOF
        config_file = File.join(dir, 'config_file')
        File.write(config_file, yaml)
        config = util.load_and_validate('target', config_file)
        expect(config['templates_dir']).to eq './kanagata'

        attributes = config['attributes']
        expect(attributes['key1']).to eq 'value1'
        expect(attributes['key2']).to eq 'value2'
        expect(attributes['array']).to eq [1, 2]

        templates = config['templates']
        expect(templates[0]['path']).to eq './hoge.json'
        expect(templates[1]['path']).to eq './fuga.rb'
        expect(templates[1]['name']).to eq '<%= key1 %>.rb'
      end
    end
  end

  context '#attributes' do
    it 'empty config_attributes' do
      config_attributes = {}
      args_attributes = ['key:value', 'abc:123']
      attributes = util.merge_attributes(config_attributes, args_attributes)
      expect(attributes['key']).to  eq 'value'
      expect(attributes['abc']).to  eq '123'
    end

    it 'empty args_attributes' do
      config_attributes = {
        'key1' => 'value1',
        'key2' => 'value2',
      }
      args_attributes = []
      attributes = util.merge_attributes(config_attributes, args_attributes)
      expect(attributes['key1']).to eq 'value1'
      expect(attributes['key2']).to eq 'value2'
    end

    it 'merge attributes' do
      config_attributes = {
        'key1' => 'value1',
        'key2' => 'value2',
      }
      args_attributes = ['key:value', 'abc:123']
      attributes = util.merge_attributes(config_attributes, args_attributes)
      expect(attributes['key1']).to eq 'value1'
      expect(attributes['key2']).to eq 'value2'
      expect(attributes['key']).to  eq 'value'
      expect(attributes['abc']).to  eq '123'
    end
  end

  context '#validate' do
    before do
      @hash = {hoge: 100}
    end

    it 'key exists' do
      expect {
        util.validate(@hash, :hoge)
      }.to_not raise_error
    end

    it 'key not found' do
      expect {
        util.validate(@hash, :fuga)
      }.to raise_error
    end
  end

  it '#relative_path_of' do
    expect(util.relative_path_of(__FILE__)).to eq Pathname.new('spec/lib/kanagata/util_spec.rb')
  end

  it '#info' do
    expect {
      util.info('hoge')
    }.to output("\thoge\n").to_stdout
  end
end
