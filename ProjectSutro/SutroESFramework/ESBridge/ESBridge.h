//
//  ESBridge.h
//  SutroESFramework
//
//  Created by Brandon Dalton on 11/7/22.
//

#ifndef ESBridge_h
#define ESBridge_h

#import <EndpointSecurity/EndpointSecurity.h>
#include <stdio.h>
#include <sys/proc_info.h>

#define PROC_PIDUNIQIDENTIFIERINFO      17
#define PROC_PIDUNIQIDENTIFIERINFO_SIZE \ (sizeof(struct proc_uniqidentifierinfo))


/* CSR configuration flags */
#define CSR_ALLOW_UNTRUSTED_KEXTS               (1 << 0)
#define CSR_ALLOW_UNRESTRICTED_FS               (1 << 1)
#define CSR_ALLOW_TASK_FOR_PID                  (1 << 2)
#define CSR_ALLOW_KERNEL_DEBUGGER               (1 << 3)
#define CSR_ALLOW_APPLE_INTERNAL                (1 << 4)
#define CSR_ALLOW_DESTRUCTIVE_DTRACE                    (1 << 5) /* name deprecated */
#define CSR_ALLOW_UNRESTRICTED_DTRACE                   (1 << 5)
#define CSR_ALLOW_UNRESTRICTED_NVRAM                    (1 << 6)
#define CSR_ALLOW_DEVICE_CONFIGURATION                  (1 << 7)
#define CSR_ALLOW_ANY_RECOVERY_OS                       (1 << 8)
#define CSR_ALLOW_UNAPPROVED_KEXTS                      (1 << 9)
#define CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE    (1 << 10)
#define CSR_ALLOW_UNAUTHENTICATED_ROOT                  (1 << 11)


static const char *csr_mask_string[] = {
    "CSR_ALLOW_UNTRUSTED_KEXTS",
    "CSR_ALLOW_UNRESTRICTED_FS",
    "CSR_ALLOW_TASK_FOR_PID",
    "CSR_ALLOW_KERNEL_DEBUGGER",
    "CSR_ALLOW_APPLE_INTERNAL",
    "CSR_ALLOW_DESTRUCTIVE_DTRACE",
    "CSR_ALLOW_UNRESTRICTED_DTRACE",
    "CSR_ALLOW_UNRESTRICTED_NVRAM",
    "CSR_ALLOW_DEVICE_CONFIGURATION",
    "CSR_ALLOW_ANY_RECOVERY_OS",
    "CSR_ALLOW_UNAPPROVED_KEXTS",
    "CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE",
    "CSR_ALLOW_UNAUTHENTICATED_ROOT",
};

typedef uint32_t csr_config_t;
extern int csr_get_active_config(csr_config_t *);
extern int csr_check(csr_config_t);


struct csr_config
{
    char** key;
};

// @discussion it looks like Jamf Protect is also using the main executable UUID for their
//             process unique ID. Sample: `d3928ece-4c4b-4001-a0b8-8c07ff5ee157`.
//             As represented by by `PROC_PIDUNIQIDENTIFIERINFO`: `86880a73-849b-3858-a5ef-902dfbc96b30`.
struct proc_uniqidentifierinfo {
    uint8_t                 p_uuid[16];             /* UUID of the main executable */
    uint64_t                p_uniqueid;             /* 64 bit unique identifier for process */
    uint64_t                p_puniqueid;            /* unique identifier for process's parent */
    int32_t                 p_idversion;            /* pid version */
    uint32_t                p_reserve2;             /* reserved for future use */
    uint64_t                p_reserve3;             /* reserved for future use */
    uint64_t                p_reserve4;             /* reserved for future use */
};

es_muted_paths_t* fetch_muted_paths(es_client_t* es_client);
void release_es_memory(es_muted_paths_t *muted_paths);


struct proc_uniqidentifierinfo get_pid_info(pid_t pid);
csr_config_t getCSRConfig(void);

//char* proc_info_to_string(struct proc_uniqidentifierinfo proc_info);
//audit_token_t fetch_audit_token(pid_t pid);

#endif /* ESBridge_h */
