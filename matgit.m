function matgit(varargin)

if ispc()
    backup_dir = [getenv('USERPROFILE'), '/Dropbox/WORKS/matlab_sync/'];
end

if ismac()
    backup_dir = '~/Dropbox/WORKS/matlab_sync/';
end


if nargin~=1
    disp('Check input parameters!');
    disp('Usage: matgit [OPTION]');
    disp('OPTION');
    disp('  push : zip and push to Dropbox directory');
    disp('  pull : Copy from dropbox dir. and extract the zip file');
    disp(' ');    
    return
end


switch(varargin{1})
    case 'push'     
        [~, zip_name_proc, ~] = fileparts(pwd)
        zip_name = [zip_name_proc, '.zip']
        cur_dir = pwd;
        
        fprintf('Backup is processing...\n');
        fprintf('    Creating zip file...\n');
        
        dirinfo = dir;
        list_tobe_zipped = {}; %cell(length(dirinfo),1);
        % zip(zip_name, cur_dir);
        
        for cnt = 1:length(dirinfo)
            if dirinfo(cnt).isdir == 0
                list_tobe_zipped = [list_tobe_zipped; {['./',zip_name_proc,'/',dirinfo(cnt).name]}];
            end
        end
        cd ..;
        
        zip(zip_name, list_tobe_zipped);
        % clear('cnt', 'dirinfo', 'list_tobe_zipped');
        
        fprintf('    Zip complete!\n');
        fprintf('    Copying to the Dropbox folder...\n');
        
        copyfile(zip_name, backup_dir);
        
        fprintf('    Copy completed!\n');
        fprintf('    Removing temporary files...\n');
        delete(zip_name);
        
        cd(cur_dir);
        
        fprintf('Backup is completed!\n');
        
    case 'pull'
        [~, zip_name_proc, ~] = fileparts(pwd)
        zip_name = [zip_name_proc, '.zip']
        cur_dir = pwd;
        cd ..;
        parent_dir = pwd;
        
        
        fprintf('Restore from backup is processing...\n');
        
        cd(backup_dir);
        copyfile(zip_name, parent_dir);
        
        cd(parent_dir);
        unzip(zip_name);
        delete(zip_name);
        cd(cur_dir);
        
        fprintf('Restore is completed!\n');
        
    otherwise
        disp('Check input parameters!');
        disp('Usage: matgit [OPTION]');
        disp('OPTION');
        disp('  push : zip and push to Dropbox directory');
        disp('  pull : Copy from dropbox dir. and extract the zip file');
        disp(' ');
        return
end


