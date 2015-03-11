# Helper methods to setup state for GitTransactor Base examples
module GitTransactor
  module Setup
    module Base
      def setup_initial_state
        tr = TestRepo.new(repo_path)
        tr.nuke
        tr.init
        tr.create_file('foo.txt','foo.txt')
        tr.add('foo.txt')
        tr.commit('Initial commit')

        tq = TestQueue.new(work_root)
        tq.nuke
        tq.init

        tsd = TestSourceDir.new(source_path)
        tsd.nuke
        tsd.init
      end

      def setup_add_state
        sub_directory = 'jgp'
        src_file = "interesting-stuff.xml"

        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end

      def setup_add_state_2
        sub_directory_2 = 'khq'
        src_file_2 = 'more-interesting-stuff.xml'
        tsd.create_sub_directory(sub_directory_2)
        tsd.create_file(File.join(sub_directory_2, src_file_2), "#{src_file_2}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory_2, src_file_2)))
      end

      def setup_add_state_3
        sub_directory = 'jgp'
        src_file = "super-cool-stuff.xml"

        tsd.create_sub_directory(sub_directory)
        tsd.create_file(File.join(sub_directory, src_file), "#{src_file}")
        tq.enqueue('add', File.expand_path(File.join(tsd.path, sub_directory, src_file)))
      end

      def setup_add_same_subdir_state
        setup_add_state
        setup_add_state_3
      end

      def setup_rm_state
        sub_directory = 'pgj'
        file_to_rm = "spiffingly-interesting.xml"
        file_to_rm_rel_path = File.join(sub_directory, file_to_rm)

        tr.create_sub_directory(sub_directory)
        tr.create_file(file_to_rm_rel_path, "#{file_to_rm}")

        g = Git.open(repo_path)
        g.add(file_to_rm_rel_path)
        g.commit("add test file")

        tq.enqueue('rm', File.expand_path(File.join(source_path, file_to_rm_rel_path)))
      end

      def setup_push_state
        trr = TestRepo.new(remote_url, bare: true)
        trr.nuke
        trr.init

        td  = TestDir.new(local_repo_parent)
        td.nuke
        td.create_root

        Git.clone(trr.path, local_repo_name, path: td.path)

        local_repo = TestRepo.new(local_repo_path)
        local_repo.open
        local_repo.create_file('unicorns.txt', 'and rainbows!')
        local_repo.add('unicorns.txt')
        local_repo.commit('add unicorns and rainbows!')
      end
    end
  end
end
