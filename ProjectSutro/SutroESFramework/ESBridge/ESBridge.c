//
//  ESBridge.c
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/7/22.
//

#include "ESBridge.h"
//#include <libproc.h>
#include <stdlib.h>
#include <mach/task.h>
#include <mach/mach.h>
#include <libproc.h>
#include <sys/proc_info.h>

struct message
{
    mach_msg_header_t header;
    char data[256];
    mach_msg_audit_trailer_t trailer;
};

es_muted_paths_t* fetch_muted_paths(es_client_t* es_client) {
    es_muted_paths_t *muted_paths = NULL;
    es_muted_paths_events(es_client, &muted_paths);
    return muted_paths;
}

void release_es_memory(es_muted_paths_t *muted_paths) {
    es_release_muted_paths(muted_paths);
}




//char *proc_info_to_string(struct proc_uniqidentifierinfo proc_info) {
//    char buffer[512];
//    // UUID-unique_id-parent_unique_id-pid_version
//    int ret = snprintf(buffer, sizeof(buffer),
//    "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x-%llu-%llu-%d",
//    proc_info.p_uuid[0], proc_info.p_uuid[1], proc_info.p_uuid[2], proc_info.p_uuid[3], proc_info.p_uuid[4], proc_info.p_uuid[5], proc_info.p_uuid[6], proc_info.p_uuid[7],
//    proc_info.p_uuid[8], proc_info.p_uuid[9], proc_info.p_uuid[10], proc_info.p_uuid[11], proc_info.p_uuid[12], proc_info.p_uuid[13], proc_info.p_uuid[14], proc_info.p_uuid[15],
//    proc_info.p_uniqueid, proc_info.p_puniqueid, proc_info.p_idversion);
//    if (ret < 0) {
//        fprintf(stderr, "snprintf failed\n");
//        return NULL;
//    }
//    
//    char *string = strdup(buffer);
//    if (string == NULL) {
//        fprintf(stderr, "strdup failed\n");
//        return NULL;
//    }
//    
//    return string;
//}


struct proc_uniqidentifierinfo get_pid_info(pid_t pid) {
    struct proc_uniqidentifierinfo proc_info;
    int ret = proc_pidinfo(pid, PROC_PIDUNIQIDENTIFIERINFO, 0, &proc_info, sizeof(struct proc_uniqidentifierinfo));

    if (ret != sizeof(proc_info)) {
        fprintf(stderr, "proc_pidinfo failed\n");
        return proc_info;
    }

    return proc_info;
}



//audit_token_t fetch_audit_token(pid_t pid) {
//    task_name_t task;
//    kern_return_t kr;
//
//    kr = task_name_for_pid(mach_task_self(), pid, &task);
//    if (kr != KERN_SUCCESS) {
//        printf("Error getting task name\n");
//    }
//
//    mach_port_t server_port;
//    struct message msg;
//    kern_return_t kr_audit;
//
//    audit_token_t token;
//    mach_msg_type_number_t size = TASK_AUDIT_TOKEN_COUNT;
//
//    kr_audit = task_info(task, TASK_AUDIT_TOKEN, (task_info_t)&token, &size);
//    if (kr_audit != KERN_SUCCESS) {
//        printf("Error getting task audit_token\n");
//    }
//
//    return token;
//}
