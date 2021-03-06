require 'torch'
require 'nn'

require '../core/autoencoder16.lua'
require '../io/lmdb_reader'
require 'image'

defaults = {
  batch_size = 4,
  n_batches = 4,
  save_prefix = '.'
}

cmd = torch.CmdLine()
cmd:argument('net_path', 'network to load')
cmd:argument('data_path', 'lmdb database to test on')
cmd:option('-batch_size', defaults.batch_size, 'batch size')
cmd:option('-n_batches', defaults.n_batches, 'number of batches')
cmd:option('-save_prefix', defaults.save_prefix, 'number of batches')


options = cmd:parse(arg)

print(options)

imagenet_reader = lmdb_reader(options.data_path)

ae = autoencoder()

ae:initialize()

ae:load(options.net_path)

for i=1, options.n_batches do
  data_batch = imagenet_reader:get_data(options.batch_size)
  for j=1, options.batch_size do
    local input_filename = options.save_prefix .. '/' .. '16_input_' .. i .. '_' .. j .. '.jpg'
    local output_filename = options.save_prefix .. '/' .. '16_output_' .. i .. '_' .. j .. '.jpg'

    input = data_batch[j][1]

    image.save(input_filename, input)

    result = ae:forward(input)

    image.save(output_filename, result)
  end
end
