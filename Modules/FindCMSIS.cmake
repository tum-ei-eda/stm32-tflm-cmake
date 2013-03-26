SET(STM32_CHIP_DEF_HD "STM32F10X_HD")
SET(STM32_CHIP_DEF_HD_VL "STM32F10X_HD_VL")
SET(STM32_CHIP_DEF_MD "STM32F10X_MD")
SET(STM32_CHIP_DEF_MD_VL "STM32F10X_MD_VL")
SET(STM32_CHIP_DEF_LD "STM32F10X_LD")
SET(STM32_CHIP_DEF_LD_VL "STM32F10X_LD_VL")
SET(STM32_CHIP_DEF_CL "STM32F10X_CL")
SET(STM32_CHIP_DEF_XL "STM32F10X_XL")

SET(CMSIS_LIB_NAME_HD "cmsis_hd")
SET(CMSIS_LIB_NAME_HD_VL "cmsis_hd_vl")
SET(CMSIS_LIB_NAME_MD "cmsis_md")
SET(CMSIS_LIB_NAME_MD_VL "cmsis_md_vl")
SET(CMSIS_LIB_NAME_LD "cmsis_ld")
SET(CMSIS_LIB_NAME_LD_VL "cmsis_ld_vl")
SET(CMSIS_LIB_NAME_CL "cmsis_cl")
SET(CMSIS_LIB_NAME_XL "cmsis_xl")

SET(CMSIS_STARTUP_SOURCE_HD "startup_stm32f10x_hd.s")
SET(CMSIS_STARTUP_SOURCE_HD_VL "startup_stm32f10x_hd_vl.s")
SET(CMSIS_STARTUP_SOURCE_MD "startup_stm32f10x_md.s")
SET(CMSIS_STARTUP_SOURCE_MD_VL "startup_stm32f10x_md_vl.s")
SET(CMSIS_STARTUP_SOURCE_LD "startup_stm32f10x_ld.s")
SET(CMSIS_STARTUP_SOURCE_LD_VL "startup_stm32f10x_ld_vl.s")
SET(CMSIS_STARTUP_SOURCE_CL "startup_stm32f10x_cl.s")
SET(CMSIS_STARTUP_SOURCE_XL "startup_stm32f10x_xl.s")

IF(NOT STM32_CHIP_TYPE)
    MESSAGE(STATUS "No stm32 chip selected. You will have to use chip specific variables, i.e. STM32_CHIP_DEF_HD. You can select stm32 chip using STM32_CHIP_TYPE variable. (HD, HD_VL, MD, MD_VL, LD, LD_VL, XL, CL)")
    UNSET(CMSIS_STARTUP_NAME)
    UNSET(CMSIS_STARTUP_SOURCE)
    UNSET(STM32_CHIP_DEF)
    SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_HD} ${CMSIS_LIB_NAME_HD_VL} ${CMSIS_LIB_NAME_MD} ${CMSIS_LIB_NAME_MD_VL} ${CMSIS_LIB_NAME_LD} ${CMSIS_LIB_NAME_LD_VL} ${CMSIS_LIB_NAME_CL} ${CMSIS_LIB_NAME_XL})
ELSE()
    IF(STM32_CHIP_TYPE STREQUAL "HD")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_HD})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_HD})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_HD})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "HD_VL")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_HD_VL})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_HD_VL})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_HD_VL})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "MD")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_MD})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_MD})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_MD})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "MD_VL")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_MD_VL})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_MD_VL})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_MD_VL})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "LD")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_LD})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_LD})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_LD})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "LD_VL")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_LD_VL})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_LD_VL})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_LD_VL})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "XL")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_XL})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_XL})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_XL})
    ELSEIF(STM32_CHIP_TYPE STREQUAL "CL")
        SET(CMSIS_FIND_LIBS ${CMSIS_LIB_NAME_CL})
        SET(CMSIS_STARTUP_NAME ${CMSIS_STARTUP_SOURCE_CL})
        SET(STM32_CHIP_DEF ${STM32_CHIP_DEF_CL})
    ELSE()
        MESSAGE(FATAL_ERROR "Invalid stm32 chip type.")
    ENDIF()
ENDIF()

FIND_PATH(CMSIS_INCLUDE_DIR system_stm32f10x.h core_cm3.h stm32f10x.h 
    PATH_SUFFIXES include stm32
)

FOREACH(CMSIS_LIB_NAME ${CMSIS_FIND_LIBS})
    SET(CMSIS_LIBRARY CMSIS_LIBRARY-NOTFOUND)
    FIND_LIBRARY(CMSIS_LIBRARY
        NAMES ${CMSIS_LIB_NAME}
        PATH_SUFFIXES lib
    )
    SET(CMSIS_LIBRARIES ${CMSIS_LIBRARIES} ${CMSIS_LIBRARY})
ENDFOREACH()

FIND_FILE(CMSIS_LINKER_SCRIPT
    stm32_flash.ld.in
    PATHS ${CMAKE_FIND_ROOT_PATH}/share/cmsis/
)

INCLUDE(FindPackageHandleStandardArgs)
IF(NOT STM32_CHIP_TYPE)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(CMSIS DEFAULT_MSG CMSIS_LIBRARIES CMSIS_INCLUDE_DIR CMSIS_LINKER_SCRIPT STM32_CHIP_DEF_HD STM32_CHIP_DEF_HD_VL STM32_CHIP_DEF_MD STM32_CHIP_DEF_MD_VL STM32_CHIP_DEF_LD STM32_CHIP_DEF_LD_VL STM32_CHIP_DEF_XL STM32_CHIP_DEF_CL) 
ELSE()
    FIND_FILE(CMSIS_STARTUP_SOURCE
        ${CMSIS_STARTUP_NAME}
        PATHS ${CMAKE_FIND_ROOT_PATH}/share/cmsis/
    )
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D${STM32_CHIP_DEF}")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D${STM32_CHIP_DEF}")
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(CMSIS DEFAULT_MSG CMSIS_LIBRARIES CMSIS_INCLUDE_DIR CMSIS_STARTUP_SOURCE CMSIS_LINKER_SCRIPT STM32_CHIP_DEF) 
ENDIF()

FUNCTION(STM32_SET_PARAMS FLASH_SIZE RAM_SIZE STACK_ADDRESS MIN_STACK_SIZE MIN_HEAP_SIZE EXT_RAM_SIZE FLASH_ORIGIN RAM_ORIGIN EXT_RAM_ORIGIN)
    CONFIGURE_FILE(${CMSIS_LINKER_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/stm32_flash.ld)
ENDFUNCTION(STM32_SET_PARAMS)

FUNCTION(STM32_SET_PARAMS FLASH_SIZE RAM_SIZE STACK_ADDRESS)
    SET(STACK_ADDRESS ${STACK_ADDRESS})
    SET(FLASH_SIZE ${FLASH_SIZE})
    SET(RAM_SIZE ${RAM_SIZE})
    SET(MIN_STACK_SIZE "0x200")
    SET(MIN_HEAP_SIZE "0")
    SET(EXT_RAM_SIZE "0K")
    SET(FLASH_ORIGIN "0x08000000")
    SET(RAM_ORIGIN "0x20000000")
    SET(EXT_RAM_ORIGIN "0x60000000")
    CONFIGURE_FILE(${CMSIS_LINKER_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/stm32_flash.ld)
ENDFUNCTION(STM32_SET_PARAMS)