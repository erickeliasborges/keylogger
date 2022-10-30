package com.example.keylogger;

import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "keylogger")
public class KeyLogger {

    @Id
    @SequenceGenerator(name = "keylogger_id_sequence", sequenceName = "keylogger_id_sequence", allocationSize = 1, initialValue = 1)
    @GeneratedValue(generator = "keylogger_id_sequence")
    private Long id;

    @Column(name = "inclusion_date", updatable = false)
    @NotNull
    private LocalDateTime inclusionDate;

    @Column(name = "from_host_address")
    private String fromHostAddress;

    @Column(name = "from_host_name")
    private String fromHostName;

    @Column(columnDefinition = "text")
    @NotNull
    private String log;

}
