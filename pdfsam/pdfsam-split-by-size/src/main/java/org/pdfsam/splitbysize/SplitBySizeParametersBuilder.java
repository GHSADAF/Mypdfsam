/* 
 * This file is part of the PDF Split And Merge source code
 * Created on 26/giu/2014
 * Copyright 2017 by Sober Lemur S.a.s. di Vacondio Andrea (info@pdfsam.org).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as 
 * published by the Free Software Foundation, either version 3 of the 
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.pdfsam.splitbysize;

import org.pdfsam.support.params.SplitParametersBuilder;
import org.sejda.model.parameter.SplitBySizeParameters;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Builder for {@link SplitBySizeParameters}
 * 
 * @author Andrea Vacondio
 *
 */
class SplitBySizeParametersBuilder extends SplitParametersBuilder<SplitBySizeParameters> {

    private long size;
    private  static final Logger LOG = LoggerFactory.getLogger(SplitBySizeParametersBuilder.class);

    void size(long size) {
        this.size = size;
    }

    @Override
    public SplitBySizeParameters build() {
        SplitBySizeParameters params = new SplitBySizeParameters(size);
        params.setCompress(isCompress());
        params.setExistingOutputPolicy(existingOutput());
        params.setVersion(getVersion());
        params.setOutput(getOutput());
        params.setOutputPrefix(getPrefix());
        params.addSource(getSource());
        params.setOptimizationPolicy(getOptimizationPolicy());
        params.discardOutline(isDiscardBookmarks());
        LOG.info("SplitBuilder:: BUG::: size={0}, size_set={1}",size,params.getSizeToSplitAt(),params.hashCode());
        return params;
    }
}
